{ config, pkgs, ... }:

{
  environment =
  let system_vim = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        " no startup message
        set shortmess+=I
        " visual theme
        let g:gitgutter_override_sign_column_highlight=0
        let g:gitgutter_sign_modified='*'
        set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
        " colorscheme
        set background=dark
        colorscheme base16-default-dark
        hi Normal           ctermfg=15
        hi LineNr           ctermfg=8     ctermbg=NONE
        hi CursorLineNr     ctermfg=7     ctermbg=NONE
        hi CursorLine       ctermbg=NONE
        hi SignColumn       ctermbg=NONE
        hi GitGutterAdd     ctermbg=NONE  ctermfg=11
        hi GitGutterChange  ctermbg=NONE  ctermfg=9
        hi GitGutterDelete  ctermbg=NONE  ctermfg=1
        hi TabLine          ctermbg=NONE
        hi TabLineFill      ctermbg=NONE
        hi TabLineSel       ctermbg=8     ctermfg=15
        hi StatusLine       ctermbg=NONE
        hi StatusLineNC     ctermbg=NONE  ctermfg=8
        hi Pmenu            ctermbg=8     ctermfg=7
        hi PmenuSel         ctermbg=8     ctermfg=15
        hi IncSearch        ctermbg=8     ctermfg=15
        hi Search           ctermbg=8     ctermfg=NONE
        hi Visual           ctermbg=8     ctermfg=15
        hi WildMenu         ctermbg=8     ctermfg=15
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
        " minimum column width
        set numberwidth=1
        " highlight current line
        set cursorline
        " show matching brackets
        set showmatch
        " ignore files in menu
        set wildignore=*.o,*~,*.pyc,*.so,*.class,.DS_Store
        set wildmode=longest:full,full
        " turn on syntax completion
        set omnifunc=syntaxcomplete#Complete
        set completeopt=menuone,noinsert
        let g:deoplete#enable_at_startup = 1
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
        " show tabline when tabs >1
        set showtabline=1
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
        vim-sensible editorconfig-vim fugitive gitgutter ale vim-nix base16-vim deoplete-nvim
      ];
    };
  });
  in
  {
    systemPackages = [ (system_vim) pkgs.nvi ];
  };
}

