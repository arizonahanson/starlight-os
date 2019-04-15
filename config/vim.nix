{ config, pkgs, ... }:

{
  environment = 
  let vim_custom = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        " no startup message
        set shortmess+=I
        " visual theme
        set background=dark
        set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
        " turn backup off
        set nobackup
        set nowb
        set noswapfile
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

