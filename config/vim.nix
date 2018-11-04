{ config, pkgs, ... }:

{
  programs.vim.defaultEditor = true;
  environment.systemPackages = with pkgs; [
    
  ];
}

