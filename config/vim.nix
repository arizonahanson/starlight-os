{ config, pkgs, ... }:

{
  programs.vim.defaultEditor = true;
  environment.systemPackages = with pkgs; [
    (with import <nixpkgs> {};
      vim_configurable.customize {
        # Specifies the vim binary name.
        # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
        # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
        name = "vim";
      	vimrcConfig.customRC = ''
      	  " Here one can specify what usually goes into `~/.vimrc` 
      	  syntax enable
      	'';
      	vimrcConfig.packages.vim = with pkgs.vimPlugins; {
      	  # loaded on launch
      	  start = [ ale fugitive vim-nix vim-sensible ];
      	  # manually loadable by calling `:packadd $plugin-name`
      	  #opt = [ phpCompletion elm-vim ];
      	  # To automatically load a plugin when opening a filetype, add vimrc lines like:
      	  # autocmd FileType php :packadd phpCompletion
      	};
      }
    )    
  ];
}

