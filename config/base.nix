{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnumake git
    wget
    vim
    zsh
    pstree
    tree
  ];
}
