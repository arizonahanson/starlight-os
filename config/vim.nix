{ config, pkgs, ... }:

{
  environment = 
  let vim_custom = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        " system vimrc
      '';
      plug.plugins = with pkgs.vimPlugins; [
        vim-sensible editorconfig-vim fugitive gitgutter ale vim-nix
      ];
    };
  });
  in
  {
    systemPackages = [ (vim_custom) ];
  };
}

