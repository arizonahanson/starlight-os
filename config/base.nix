{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./networking.nix
    ./zsh.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];
  options.starlight = {
    localTime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use local time (dual boot)
      '';
    };
    insertCursor = mkOption {
      type = types.int;
      default = 5;
      description = ''
        cursor code for insert mode
      '';
    };
    replaceCursor = mkOption {
      type = types.int;
      default = 3;
      description = ''
        cursor code for replace mode
      '';
    };
    commandCursor = mkOption {
      type = types.int;
      default = 1;
      description = ''
        cursor code for command mode
      '';
    };
  };
  config = let
    theme = config.starlight.theme;
    colorMap = {
      "0" = 0; "8" = 1; "7" = 2; "15" = 3; "1" = 4; "9" = 5; "3" = 6; "11" = 7;
      "2" = 8; "10" = 9; "6" = 10; "14" = 11; "4" = 12; "12" = 13; "5" = 14; "13" = 15;
    };
    colorIndex = num: colorMap.${toString num};
    colorSort = a: b: lessThan (colorIndex theme.${a}) (colorIndex theme.${b});
    toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
  in
    mkMerge [
      {
        boot = {
          tmpOnTmpfs = true;
          kernelParams = [ "quiet" ];
          consoleLogLevel = 0;
          kernel.sysctl = {
            "vm.max_map_count" = 262144;
          };
        };
        fileSystems = {
          "/".options = [ "compress-force=zstd" ];
          "/home".options = [ "compress-force=zstd" ];
        };
        services.btrfs.autoScrub = {
          enable = true;
          fileSystems = [ "/" ];
        };
				systemd.timers.nixos-upgrade = {
					description = "NixOS Upgrade Timer";
					wantedBy = [ "timers.target" ];
					timerConfig.OnStartupSec = "1min";
				};
        systemd.services.nixos-upgrade = {
					description = "NixOS Upgrade";
					restartIfChanged = false;
					unitConfig.X-StopOnRemoval = false;
					serviceConfig.Type = "oneshot";

					environment = config.nix.envVars //
						{ inherit (config.environment.sessionVariables) NIX_PATH;
							HOME = "/root";
						} // config.networking.proxy.envVars;

					path = with pkgs; [ coreutils gnutar xz.bin gzip gitMinimal config.nix.package.out ];

					script = let
            nixos-gc = "${config.nix.package.out}/bin/nix-collect-garbage}";
            nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
						in
						''
              ${nixos-gc} --delete-older-than 4w
              ${nixos-rebuild} switch --upgrade
						'';
        };
        nix.autoOptimiseStore = true;
        systemd.tmpfiles.rules = [
          "d /run/cache/ 1771 - users"
          "d /var/config/ 1771 - users 4w"
          "e /var/tmp/ - - - 2w"
        ];
        nixpkgs.config.allowUnfree = true;
        environment.pathsToLink = [ "/include" ];
        environment.systemPackages = with pkgs; [
          gnumake
          bc
          gcc
          julia_11
          binutils
          psmisc
          pciutils
          tree
          ag
          fzf
          zip
          unzip
          duperemove
          compsize
          nox
          ncdu
          stow
          shellcheck
          (
            with import <nixpkgs> {}; writeShellScriptBin "palette" ''
              for bold in 0 1; do
                for col in {0..7}; do
                  echo -en "\e[$bold;3''${col}m "
                done; echo
              done; echo
              for col in 0 7 1 3 2 6 4 5; do
                echo -en "\e[0;3''${col}m \e[1;3''${col}m "
              done; echo
            ''
          )
          (
            with import <nixpkgs> {}; writeShellScriptBin "theme"
              ((concatStringsSep "\n" (
                map (name: "echo -en '\\e[${toANSI theme.${name}}m" + name + "\\e[0m '")
                (sort colorSort (attrNames theme))))
                + "\necho"
              )
          )
        ] ++ optional config.starlight.efi gptfdisk;
        services.journald.extraConfig = ''
          Storage=volatile
        '';
        time.hardwareClockInLocalTime = config.starlight.localTime;
        # default user account
        users.users.admin = let
          virtual = config.virtualisation.virtualbox.guest.enable;
        in {
          isNormalUser = true;
          uid = 1000;
          description = "Administrator";
          extraGroups = [ "wheel" ] ++ optional virtual "vboxsf";
          initialHashedPassword = "$6$D85LJu3AY7$CSbcP8wY9qNgp6zA.PXAmZo6JMy4nHDldvfUDzom7XglfgRUPW6wnLJ1l0dRUQAy4SReAO85GEISAs6tZE6TV/";
        };
        users.defaultUserShell = "/run/current-system/sw/bin/zsh";
        users.mutableUsers = true;

        # This value determines the NixOS release with which your system is to be
        # compatible, in order to avoid breaking some software such as database
        # servers. You should change this only after NixOS release notes say you
        # should.
        system.stateVersion = "19.09"; # Did you read the comment?
      }
    ];
}
