{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    environment = {
      etc."skel/.zshrc" = {
        text = ''
          # zshrc skeleton file
        '';
      };
      # in set-environment (earliest sh)
      extraInit = ''
        umask 077
      '';
    };
    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
      # zprofile (once, before zshrc)
      loginShellInit = ''
        mkdir -p "$XDG_CACHE_HOME"
        mkdir -p "$XDG_CONFIG_HOME"
      '';
    };
  };
}
