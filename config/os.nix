{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (with import <nixpkgs> {}; writeShellScriptBin "os-update" ''
      #!/usr/bin/env bash
      
      cd /tmp
      git clone --depth 1 https://github.com/isaacwhanson/starlight-os.git starlight-os
      cd starlight-os
	    sudo cp -a config/. /etc/nixos/
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

