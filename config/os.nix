{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
      #!/usr/bin/env bash
 
      sudo nixos-rebuild --upgrade switch
      sudo nix-collect-garbage
      flatpak update -y
    '')
    (with import <nixpkgs> {}; writeShellScriptBin "os-drop" ''
      #!/usr/bin/env bash
 
      sudo nix-collect-garbage -d
    '')
  ];
}

