{ config, pkgs, ... }:

{
  environment = let system_vim = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        " no startup message
        set shortmess+=I
        " recursive pathfinding
        set path+=**
        " visual theme
        let g:gitgutter_override_sign_column_highlight=0
        let g:gitgutter_sign_modified='*'
        set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
        " colorscheme
        set background=dark
        colorscheme base16-default-dark
        hi Normal       ctermfg=15
        hi LineNr       ctermfg=8     ctermbg=NONE
        hi CursorLineNr ctermfg=7     ctermbg=NONE
        hi CursorLine   ctermbg=NONE
        hi SignColumn   ctermbg=NONE
        hi DiffAdd                ctermbg=NONE  ctermfg=11
        hi GitGutterAdd           ctermbg=NONE  ctermfg=11
        hi DiffChange             ctermbg=NONE  ctermfg=9
        hi GitGutterChange        ctermbg=NONE  ctermfg=9
        hi DiffDelete             ctermbg=NONE  ctermfg=1
        hi GitGutterAddDelete     ctermbg=NONE  ctermfg=1
        hi GitGutterChangeDelete  ctermbg=NONE  ctermfg=1
        hi GitGutterDelete        ctermbg=NONE  ctermfg=1
        hi Todo         ctermbg=8     ctermfg=11
        hi SpellBad     ctermbg=NONE  ctermfg=9
        hi SpellRare    ctermbg=NONE  ctermfg=11
        hi SpellCap     ctermbg=NONE  ctermfg=11
        hi TabLine      ctermbg=NONE
        hi TabLineFill  ctermbg=NONE
        hi TabLineSel   ctermbg=8     ctermfg=15
        hi StatusLine   ctermbg=NONE
        hi StatusLineNC ctermbg=NONE  ctermfg=8
        hi Pmenu        ctermbg=8     ctermfg=7
        hi PmenuSel     ctermbg=8     ctermfg=15
        hi IncSearch    ctermbg=8     ctermfg=15
        hi Search       ctermbg=8     ctermfg=NONE
        hi Visual       ctermbg=8     ctermfg=15
        hi WildMenu     ctermbg=8     ctermfg=15
        hi Repeat       ctermfg=13
        hi Type         ctermfg=12
        hi PreProc      ctermfg=11
        hi Include      ctermfg=5
        hi Function     ctermfg=2
        hi Identifier   ctermfg=7
        hi String       ctermfg=3
        hi Boolean      ctermfg=13
        hi Number       ctermfg=14
        hi Statement    ctermfg=2
        hi Operator     ctermfg=5
        hi zshDereferencing ctermfg=7
        " turn backup off
        set nobackup
        set nowb
        set noswapfile
        " encoding
        set encoding=utf-8
        set fileencoding=utf-8
        set ffs=unix,dos,mac
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
        let g:ale_completion_enabled = 1
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
        " lines to the cursor when moving vertically using j/k
        set so=6
        " height of command bar
        set cmdheight=1
        " buffer becomes hidden when abandoned
        set hid
        " tenths of a second to blink when matching brackets
        set matchtime=2
        " no sound on errors
        set noerrorbells
        set novisualbell
        " auto complete delay
        call deoplete#custom#option('auto_complete_delay', 500)
        " do not pollute with ctags
        let g:gutentags_cache_dir='/tmp/.gutentags'
      '';
      plug.plugins = with pkgs.vimPlugins; [
        vim-sensible base16-vim editorconfig-vim fugitive gitgutter vim-polyglot vim-nix vim-gutentags ale deoplete-nvim neco-syntax
      ];
    };
  });
  in
  {
    systemPackages = [ pkgs.nvi pkgs.universal-ctags (system_vim) ];
  };
}

