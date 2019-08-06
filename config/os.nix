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
  os-update = (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
    renice 19 -p $$ >/dev/null
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
    cd "$gitdir"
    make upgrade
    cd "$HOME"
    rm "$gitdir" -rf
  '');
  os-rebuild = (with import <nixpkgs> {}; writeShellScriptBin "os-rebuild" ''
    renice 19 -p $$ >/dev/null
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
    cd "$gitdir"
    make rebuild
    cd "$HOME"
    rm "$gitdir" -rf
  '');
  os-drop = (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
    sudo nix-collect-garbage -d
    nix-env --delete-generations old
  '');
  os-squish = (with import <nixpkgs>  {}; writeShellScriptBin "os-squish" ''
    echo -e "\n\e[1;34m\e[0m Deduplicating system..."
    device="$(findmnt -nvo SOURCE /)"
    mntpnt="$(mktemp -d --tmpdir duperemove-XXXXXX)"
    mkdir -p $mntpnt
    sudo mount -o compress=lzo $device $mntpnt
    pushd $mntpnt >/dev/null
    sudo duperemove -Ardhv --hash=xxhash $(ls -d */nix) | grep "net change"
    sudo nix-store --optimise
    echo -e "\n\e[1;34m\e[0m Rebalancing filesystem..."
    sudo btrfs balance start -dusage=38 -musage=38 $mntpnt
    popd >/dev/null
    sudo umount $mntpnt
    rmdir $mntpnt
    echo -e "\n\e[1;34m\e[0m Discarding unused blocks..."
    sudo fstrim -av
  ''); in
  {
    environment.systemPackages = with pkgs; [
      (os-update) (os-rebuild) (os-drop) (os-squish)
    ];
  };
}

