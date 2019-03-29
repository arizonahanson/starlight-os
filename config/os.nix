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
  config = let osupdate = (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
    renice 19 -p $$ >/dev/null
    echo -e "Fetching configuration..."
    gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
    git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git $gitdir
    cd $gitdir
    make upgrade
    cd /tmp
    #rm $gitdir -rf
  '');
  in
  {
    environment.systemPackages = with pkgs; [
      (osupdate)
      (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
        sudo nix-collect-garbage -d
        nix-env --delete-generations old
      '')
    ];
  };
}

