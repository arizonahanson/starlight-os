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
        let g:gitgutter_sign_modified_removed='*_'
        set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
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
        let g:gutentags_cache_dir='/tmp/.gutentags-' . $USER
        " colorscheme
        set background=dark
        " grays (general)
        hi CursorLine   ctermfg=NONE  ctermbg=NONE  cterm=NONE "clear
        hi Comment      ctermbg=NONE  ctermfg=8     cterm=NONE "charcoal
        hi Identifier   ctermbg=NONE  ctermfg=7     cterm=NONE "pencil
        hi Normal       ctermbg=NONE  ctermfg=15    cterm=NONE "chalk
        hi Visual       ctermbg=8     ctermfg=NONE  cterm=NONE "highlight
        hi StatusLineNC ctermbg=8     ctermfg=7     cterm=NONE "muted
        hi StatusLine   ctermbg=8     ctermfg=15    cterm=NONE "current
        hi WildMenu     ctermbg=7     ctermfg=15    cterm=NONE "menu
        hi! link IncSearch StatusLine
        hi! link Search Visual
        hi! link LineNr Comment
        hi! link CursorLineNr Identifier
        hi! link SignColumn CursorLine
        hi! link TabLine Comment
        hi! link TabLineSel StatusLine
        hi! link TabLineFill CursorLine
        hi! link Pmenu StatusLineNC
        hi! link PmenuSel StatusLine
        " yellows (strings)
        hi String       ctermfg=3
        hi Character    ctermfg=11
        hi! link Special Character
        " cyans (consts)
        hi Number       ctermfg=6
        hi Constant     ctermfg=14
        hi! link Boolean Constant
        " blues (types)
        hi Function     ctermfg=4
        hi Type         ctermfg=12
        " magentas (keywords)
        hi Statement    ctermfg=5
        hi Keyword      ctermfg=13
        hi! link StorageClass Statement
        hi! link Include Statement
        hi! link PreProc Statement
        hi! link Label Keyword
        hi! link Operator Keyword
        hi! link Repeat Keyword
        " red/orange/yellow/green (status)
        hi Error        ctermbg=8     ctermfg=1
        hi Todo         ctermbg=8     ctermfg=11
        hi! link SpellCap Todo
        hi! link SpellRare Todo
        hi! link SpellBad Error
        hi DiffAdd      ctermbg=NONE  ctermfg=2
        hi DiffChange   ctermbg=NONE  ctermfg=9
        hi DiffDelete   ctermbg=NONE  ctermfg=1
        hi! link GitGutterAdd DiffAdd
        hi! link GitGutterChange DiffChange
        hi! link GitGutterAddDelete DiffDelete
        hi! link GitGutterChangeDelete DiffDelete
        hi! link GitGutterDelete DiffDelete
        hi! link diffAdded DiffAdd
        hi! link diffRemoved DiffDelete
        hi! link diffChanged DiffChange
        hi! link gitcommitFile DiffChange
        " misc syntax relinking
        hi! link zshDereferencing Identifier
        hi! link csLogicSymbols Operator
        hi! link csBraces Operator
      '';
      plug.plugins = with pkgs.vimPlugins; [
        vim-sensible editorconfig-vim fugitive gitgutter vim-polyglot vim-nix vim-gutentags ale neco-syntax deoplete-nvim
      ];
    };
  });
  in
  {
    systemPackages = [ pkgs.nvi pkgs.universal-ctags (system_vim) ];
  };
}
