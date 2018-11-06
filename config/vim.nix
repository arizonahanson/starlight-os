{ config, pkgs, ... }:

{
  environment = 
    let
      vim_config = pkgs.vim_configurable.override {
        features = "normal";
        guiSupport = "no";
        luaSupport = false;
        pythonSupport = false;
        rubySupport = false;
        multibyteSupport = true;
        netbeansSupport = false;
      };
      vim_minimal = (with import <nixpkgs> {}; 
        vim_config.customize {
          # Specifies the vim binary name.
          # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
          # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
          name = "vim";
          vimrcConfig = {
            packages.nix_sensible = with pkgs.vimPlugins; {
        	    # loaded on launch
              start = [ vim-sensible vim-colors-solarized ];
              # manually loadable by calling `:packadd $plugin-name`
              opt = [ vim-nix ];
              # To automatically load a plugin when opening a filetype, add vimrc lines like:
              # autocmd FileType html :packadd plugin-name
            };
            customRC = ''
              set background=light
              colorscheme solarized
              autocmd FileType nix :packadd vim-nix
            '';
          };
        }
      );
    in
  {
    variables = {
      EDITOR = "vim";
    };
    shellAliases = {
      vim-minimal = "${vim_minimal}/bin/vim";
    };
    systemPackages = with pkgs; [ (vim_minimal) ];
  };
}

