{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./grub.nix
    ./base.nix
    ./locale.nix
    ./networking.nix
    ./server.nix
    ./desktop.nix
    ./docker.nix
  ];
  config.environment.systemPackages = with pkgs; [
    (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
      gitdir="$(mktemp -d --tmpdir starlight-os_XXXXXX)"
      git clone --depth 1 https://github.com/isaacwhanson/starlight-os.git $gitdir
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

