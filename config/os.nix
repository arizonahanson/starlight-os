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
  config = 
  let osupdate = (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
    renice 19 -p $$ >/dev/null
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
    cd "$gitdir"
    make upgrade
    cd "$HOME"
    rm "$gitdir" -rf
  ''); in
  let osrebuild = (with import <nixpkgs> {}; writeShellScriptBin "os-rebuild" ''
    renice 19 -p $$ >/dev/null
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git "$gitdir"
    cd "$gitdir"
    make rebuild
    cd "$HOME"
    rm "$gitdir" -rf
  ''); in
  {
    environment.systemPackages = with pkgs; [
      (osupdate) (osrebuild)
      (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
        sudo nix-collect-garbage -d
        nix-env --delete-generations old
      '')
      (with import <nixpkgs>  {}; writeShellScriptBin "os-squish" ''
      	echo -e "\n\e[1;34m\e[0m Deduplicating system..."
	device="$(findmnt -nvo SOURCE /)"
	mntpnt="$(mktemp -d --tmpdir duperemove-XXXXXX)"
	mkdir -p $mntpnt
	sudo mount -o compress=lzo $device $mntpnt
	pushd $mntpnt >/dev/null
	sudo duperemove -Ardh --hash=xxhash system/nix >/dev/null
	echo -e "\n\e[1;34m\e[0m Rebalancing filesystem..."
	sudo btrfs balance start -dusage=70 -musage=70 $mntpnt
	popd >/dev/null
	sudo umount $mntpnt
	rmdir $mntpnt
	echo -e "\n\e[1;34m\e[0m Discarding unused blocks..."
	sudo fstrim -av
      '')
    ];
  };
}

