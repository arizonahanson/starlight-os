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
  config.environment.systemPackages = with pkgs; [
    (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
      echo -e "Fetching configuration..."
      gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
      git clone -q --depth 1 https://github.com/isaacwhanson/starlight-os.git $gitdir
      cd $gitdir
      make upgrade
      cd
      rm $gitdir -rf
    '')
    (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
      sudo nix-collect-garbage -d
    '')
  ];
}

