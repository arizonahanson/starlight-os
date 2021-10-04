{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./desktop.nix
  ];
  config =
    let
      theme = config.starlight.theme;
      toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
      os-cmd = (
        with import <nixpkgs> { }; writeShellScriptBin "os" ''
          cmd="$1"
          renice 19 -p $$ >/dev/null
          echo -e "Fetching configuration..."
          mkdir -p "/run/cache/$UID" || exit 1
          gitdir="$(mktemp -d -p "/run/cache/$UID" os-XXXX)"
          ${git}/bin/git clone -q --depth 1 https://github.com/arizonahanson/starlight-os.git "$gitdir" || exit 1
          pushd $gitdir >/dev/null || exit 1
          ${gnumake}/bin/make $1
          popd >/dev/null
          rm "$gitdir" -rf
        ''
      );
      squish = (
        with import <nixpkgs> { }; writeShellScriptBin "squish" ''
          device="$(findmnt -nvo SOURCE /)"
          mkdir -p "/run/cache/$UID" || exit 1
          mntpnt="$(mktemp -d -p "/run/cache/$UID" squish-XXXX)"
          sudo mount -o compress-force=zstd,noatime $device $mntpnt || exit 1
          pushd $mntpnt >/dev/null || exit 1
          echo -e "\n\e[${toANSI theme.path}m\e[0m Compressing system..."
          sudo btrfs filesystem defragment -r -czstd $mntpnt/*
          sync
          echo -e "\n\e[${toANSI theme.path}m\e[0m Deduplicating system..."
          sudo duperemove -Ardhv --hash=xxhash $(ls -d */nix) | grep "net change"
          sync
          echo -e "\n\e[${toANSI theme.path}m\e[0m Discarding unused blocks..."
          sudo btrfs balance start -dusage=0 -musage=0 $mntpnt >/dev/null
          sudo btrfs balance start -dusage=20 -musage=20 $mntpnt
          popd >/dev/null
          sudo umount $mntpnt || exit 1
          rmdir $mntpnt || exit 1
          sudo fstrim -av
        ''
      );
    in
    {
      systemd = {
        timers.os-upgrade = {
          description = "StarlightOS Upgrade Timer";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 04:00:00";
          };
        };
        services.os-upgrade = {
          description = "StarlightOS Upgrade Service";
          restartIfChanged = false;
          unitConfig.X-StopOnRemoval = true;
          serviceConfig = {
            Type = "oneshot";
            LimitNICE = "+1";
          };
          path = with pkgs; [
            config.nix.package.out
            config.system.build.nixos-rebuild
            bash
            coreutils
            gitMinimal
            gnumake
            gnutar
            gzip
            sudo
            systemd
            utillinux
            xz.bin
          ];
          environment = config.nix.envVars //
            {
              inherit (config.environment.sessionVariables) NIX_PATH;
              HOME = "/root";
            } // config.networking.proxy.envVars;
          script = ''
            ${os-cmd}/bin/os upgrade || exit 1
            booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
            latest="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"
            if [ ! "$booted" = "$latest" ]; then
              shutdown -r +10
            else
              ${os-cmd}/bin/os expire
            fi
          '';
        };
        timers.os-compress = {
          description = "StarlightOS Compress Timer";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "quarterly";
            AccuracySec = "1d";
            Persistent = true;
          };
        };
        services.os-compress = {
          description = "StarlightOS Compress Service";
          restartIfChanged = false;
          unitConfig.X-StopOnRemoval = true;
          serviceConfig = {
            Type = "oneshot";
            LimitNICE = "+1";
          };
          path = with pkgs; [
            sudo
            btrfs-progs
            duperemove
            utillinux
          ];
          environment = config.nix.envVars //
            {
              inherit (config.environment.sessionVariables) NIX_PATH;
              HOME = "/root";
            } // config.networking.proxy.envVars;
          script = ''
            ${squish}/bin/squish
          '';
        };
      };
      environment.systemPackages = with pkgs; [
        (os-cmd)
        (squish)
      ];
    };
}
