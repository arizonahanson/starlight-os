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
    os-update = (
      with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
        renice 19 -p $$ >/dev/null
        echo -e "Fetching configuration..."
        gitdir="$(mktemp -d -p "$XDG_CACHE_HOME" update-XXXX)"
        git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
        cd "$gitdir"
        make upgrade
        cd "$HOME"
        rm "$gitdir" -rf
      ''
    );
    os-rebuild = (
      with import <nixpkgs> {}; writeShellScriptBin "os-rebuild" ''
        renice 19 -p $$ >/dev/null
        echo -e "Fetching configuration..."
        gitdir="$(mktemp -d -p "$XDG_CACHE_HOME" rebuild-XXXX)"
        git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
        cd "$gitdir"
        make rebuild
        cd "$HOME"
        rm "$gitdir" -rf
      ''
    );
    os-drop = (
      with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
        sudo nix-collect-garbage -d
        nix-env --delete-generations old
      ''
    );
    os-squish = (
      with import <nixpkgs> {}; writeShellScriptBin "os-squish" ''
        device="$(findmnt -nvo SOURCE /)"
        mntpnt="$(mktemp -d -p "$XDG_CONFIG_HOME" squish-XXXX)"
        mkdir -p $mntpnt
        sudo mount -o compress-force=zstd,noatime $device $mntpnt
        pushd $mntpnt >/dev/null
        echo -e "\n\e[${toANSI theme.path}m\e[0m Compressing system..."
        sudo btrfs filesystem defragment -r -v -czstd $mntpnt/*
        echo -e "\n\e[${toANSI theme.path}m\e[0m Deduplicating system..."
        sudo duperemove -Ardhv --hash=xxhash $(ls -d */nix) | grep "net change"
        echo -e "\n\e[${toANSI theme.path}m\e[0m Rebalancing filesystem..."
        sudo btrfs balance start -dusage=50 -musage=50 $mntpnt
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
        (os-update)
        (os-rebuild)
        (os-drop)
        (os-squish)
      ];
    };
}
