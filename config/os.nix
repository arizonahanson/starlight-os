{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./base.nix
    ./locale.nix
    ./server.nix
    ./desktop.nix
    ./docker.nix
  ];
  config = let
    theme = config.starlight.theme;
    toANSI = num: if num <= 7 then "00;3${toString num}" else "01;3${toString (num - 8)}";
    os-cmd = (
      with import <nixpkgs> {}; writeShellScriptBin "os" ''
        cmd="$1"
        renice 19 -p $$ >/dev/null
        echo -e "Fetching configuration..."
        gitdir="$(mktemp -d -p "$XDG_CACHE_HOME" os-XXXX)"
        git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir" || exit 1
        cd "$gitdir" || exit 1
        make "$1" || exit 1
        cd "$HOME" || exit 1
        rm "$gitdir" -rf
      ''
    );
    squish = (
      with import <nixpkgs> {}; writeShellScriptBin "os-squish" ''
        device="$(findmnt -nvo SOURCE /)"
        mntpnt="$(mktemp -d -p "$XDG_CONFIG_HOME" squish-XXXX)"
        mkdir -p $mntpnt
        sudo mount -o compress-force=zstd,noatime $device $mntpnt
        pushd $mntpnt >/dev/null
        echo -e "\n\e[${toANSI theme.path}m\e[0m Compressing system..."
        sudo btrfs filesystem defragment -r -v -czstd $mntpnt/*
        sync
        echo -e "\n\e[${toANSI theme.path}m\e[0m Deduplicating system..."
        sudo duperemove -Ardhv --hash=xxhash $(ls -d */nix) | grep "net change"
        sync
        echo -e "\n\e[${toANSI theme.path}m\e[0m Rebalancing filesystem..."
        sudo btrfs balance start -dusage=50 -musage=50 $mntpnt
        sync
        popd >/dev/null
        sudo umount $mntpnt
        rmdir $mntpnt
        echo -e "\n\e[${toANSI theme.path}m\e[0m Discarding unused blocks..."
        sudo fstrim -av
      ''
    );
  in
    {
      environment.systemPackages = with pkgs; [
        (os-cmd)
        (squish)
      ];
    };
}
