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
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
        let g:gitgutter_sign_modified='*'
        " turn backup off
        set nobackup
        set nowb
        set noswapfile
        " encoding
        set encoding=utf-8
        set fileencoding=utf-8
        set ffs=unix,dos,mac
        " treat long lines as break lines
        map j gj
        map k gk
        " wrap arrow on line begin/end
        set whichwrap+=<,>,h,l
        " no timeout
        set notimeout
        set ttimeout
        " case insensitivity
        set ignorecase
        set smartcase
        " highlight search
        set hlsearch
        " min number column width
        set numberwidth=1
        " highlight current line
        "set cursorline
        " show matching brackets
        set showmatch
        " ignore files in menu
        set wildignore=*.o,*~,*.pyc,*.so,*.class,.DS_Store
        set wildmode=longest:full,full
        " turn on syntax completion
        set omnifunc=syntaxcomplete#Complete
        set completeopt=menuone,noinsert
        " shut off completion messages
        set shortmess+=c
        " no beeps during completion
        set belloff+=ctrlg
        " behavior when switching buffers
        try
          set switchbuf=useopen,usetab,newtab
          set stal=2
        catch
        endtry
        " return to last edit position when opening files
        autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
        " remember info about open buffers on close
        set viminfo^=%
        " activate spell check for some types
        autocmd FileType gitcommit set spell spelllang=en_us
        autocmd FileType markdown set spell spelllang=en_us
        " vimdiff layout
        set diffopt=filler,vertical

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

