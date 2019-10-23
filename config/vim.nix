{ config, pkgs, ... }:

{
  environment = let system_vim = (pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig = let theme = config.starlight.theme; in {
      customRC = ''
        " no startup message
        set shortmess+=I
        " recursive pathfinding
        set path+=**
        " encoding
        set encoding=utf-8
        set fileencoding=utf-8
        set ffs=unix,dos,mac
        " wrap arrow on line begin/end
        set whichwrap+=<,>,h,l
        " no timeout
        set notimeout
        set ttimeout
        " no sound on errors
        set noerrorbells
        set novisualbell
        " case insensitivity
        set ignorecase
        set smartcase
        " highlight search
        set hlsearch
        " show matching brackets
        set showmatch
        " turn-on numbers
        set number
        " minimum column width
        set numberwidth=1
        " highlight current line
        set cursorline
        " height of command bar
        set cmdheight=1
        " lines to the cursor when moving vertically using j/k
        set so=6
        " buffer becomes hidden when abandoned
        set hid
        " vimdiff layout
        set diffopt=filler,vertical
        " ignore files in menu
        set wildignore=*.o,*~,*.pyc,*.so,*.class,.DS_Store
        set wildmode=longest:full,full
        " behavior when switching buffers
        try
          set switchbuf=useopen,usetab,newtab
          set stal=2
        catch
        endtry
        " show tabline when tabs >1
        set showtabline=1
        " turn on completion
        let g:mucomplete#enable_auto_at_startup = 1
        let g:mucomplete#no_mappings = 1
        let g:mucomplete#completion_delay = 500
        set completeopt+=menuone
        set completeopt+=noselect
        " TODO: vim-polyglot doesn't include vim-styled-components omnifunc
        autocmd FileType *
          \ if &omnifunc == "" || &omnifunc == "styledcomplete#CompleteSC" |
          \   setlocal omnifunc=syntaxcomplete#Complete |
          \ endif
        " shut off completion messages
        set shortmess+=c
        " no beeps during completion
        set belloff+=ctrlg
        " temp cache directory
        let g:vimcache='/tmp/.vim-'.$USER.'/'
        let g:vimswap=g:vimcache.'swap//'
        call mkdir(g:vimswap, 'p', 0700)
        " swapfile
        set swapfile
        let &directory=g:vimswap
        " swap/cursor-hold timer
        set updatetime=500
        " backup during write
        set writebackup
        " no backup after write
        set nobackup
        " rename/write new when safe
        set backupcopy=auto
        let &backupdir=g:vimcache.'backup//'
        call mkdir(&backupdir, 'p', 0700)
        " persist undo tree
        set undofile
        let &undodir=g:vimcache.'undo//'
        call mkdir(&undodir, 'p', 0700)
        " neovim: keep buffers, large shada, relocate shada file
        "let shada_file=g:vimcache.'shada'
        "let &shada="%,!,'1000,s1024,n".shada_file
        " vim8: keep buffers, large viminfo, reloacet viminfo file
        let info_file=g:vimcache.'viminfo'
        let &viminfo="%,!,'1000,s1024,n".info_file
        " ctags
        let g:gutentags_cache_dir=g:vimcache.'ctags//'
        let g:gutentags_exclude_filetypes=["gitcommit", "gitrebase"]
        " folding commands
        set viewoptions=folds,cursor
        let &viewdir=g:vimcache.'view//'
        augroup autofold
          au!
          au BufReadPost * silent! loadview
          au BufReadPost * if auto_origami#Foldcolumn() <= 0 | setl fdm=indent | endif
          au CursorHold,BufWinEnter,WinEnter * let &foldcolumn = auto_origami#Foldcolumn()
          au BufWinEnter * if &fdm == "indent" | setl fdm=manual | silent! :%foldopen! | endif
          au BufWinLeave * silent! mkview!
        augroup END
        autocmd FileType gitcommit setlocal spell spelllang=en_us
        autocmd FileType gitcommit setlocal nonumber
        autocmd FileType gitcommit setlocal foldmethod=syntax
        autocmd FileType markdown setlocal spell spelllang=en_us
        autocmd FileType markdown setlocal nonumber
        " visual theme
        set guicursor=n-v-c-sm:block-blinkwait500-blinkon500-blinkoff500,i-ci-ve:ver25-blinkwait500-blinkon500-blinkoff500,r-cr-o:hor20-blinkwait500-blinkon500-blinkoff500
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
        let g:gitgutter_override_sign_column_highlight=0
        let g:gitgutter_sign_modified=' '
        let g:gitgutter_sign_modified_removed=' '
        let g:gitgutter_sign_added=' '
        let g:gitgutter_sign_removed=' '
        let g:ale_sign_error=' '
        let g:ale_sign_warning=' '
        let g:ale_sign_info=' '
        " colorscheme
        set background=dark
        " grays (general)
        hi Normal       ctermbg=NONE ctermfg=${toString theme.foreground} cterm=NONE
        hi Noise        ctermbg=NONE ctermfg=${toString theme.foreground-alt} cterm=NONE
        hi Identifier   ctermbg=NONE ctermfg=${toString theme.substitution} cterm=NONE
        hi Comment      ctermbg=NONE ctermfg=${toString theme.background-alt} cterm=NONE
        hi CursorLine   ctermbg=NONE ctermfg=NONE cterm=NONE
        hi Visual       ctermbg=${toString theme.background-alt} cterm=NONE
        hi StatusLine   ctermbg=${toString theme.background-alt} ctermfg=${toString theme.foreground} cterm=NONE
        hi StatusLineNC ctermbg=${toString theme.background-alt} ctermfg=${toString theme.foreground-alt} cterm=NONE
        hi WildMenu     ctermbg=${toString theme.background-alt} ctermfg=${toString theme.select} cterm=NONE
        hi PmenuThumb   ctermfg=${toString theme.foreground-alt}
        hi Underlined   ctermbg=NONE ctermfg=${toString theme.path} cterm=underline
        hi IncSearch    ctermbg=NONE ctermfg=${toString theme.match} cterm=underline
        hi Search       ctermbg=NONE ctermfg=${toString theme.match} cterm=NONE
        hi! link MatchParen Search
        hi! link LineNr Comment
        hi! link CursorLineNr Noise
        hi! link SpecialComment Noise
        hi! link Folded Noise
        hi! link FoldColumn LineNr
        hi! link SignColumn CursorLine
        hi! link TabLine Comment
        hi! link TabLineSel StatusLine
        hi! link TabLineFill CursorLine
        hi! link Pmenu StatusLineNC
        hi! link PmenuSbar StatusLineNC
        hi! link PmenuSel StatusLine
        hi! link Debug SpecialComment
        hi! link Ignore Comment
        hi! link VertSplit LineNr
        hi! link NonText Comment
        " grays (other)
        hi! link diffLine CursorLineNr
        hi! link diffFile LineNr
        hi! link diffIndexLine diffFile
        hi! link diffSubname Normal
        hi! link gitcommitHeader Comment
        hi! link gitcommitSummary Normal
        hi! link zshDereferencing Identifier
        hi! link csBraces Noise
        hi! link shShellVariables Identifier
        " strings
        hi String       ctermfg=${toString theme.string}
        hi Character    ctermfg=${toString theme.character}
        hi! link Special Character
        " other consts
        hi Number       ctermfg=${toString theme.number}
        hi Constant     ctermfg=${toString theme.constant}
        hi! link Integer Number
        hi! link Boolean Constant
        hi! link shOption Constant
        hi! link jsNull Constant
        hi! link jsThis Constant
        " functions
        hi Function     ctermfg=${toString theme.function}
        hi! link Question Function
        hi! link goBuiltins Function
        " types
        hi Type         ctermfg=${toString theme.type}
        hi! link Include Type
        " keywords, statements, operators
        hi Statement    ctermfg=${toString theme.statement}
        hi Keyword      ctermfg=${toString theme.keyword}
        hi! link Exception Keyword
        hi! link Operator Keyword
        hi! link Repeat Statement
        hi! link StorageClass Statement
        hi! link Structure Statement
        hi! link Typedef Statement
        hi! link PreProc Statement
        hi! link zshTypes Statement
        hi! link Label Statement
        hi! link csLogicSymbols Operator
        " status highlight
        hi Error        ctermbg=${toString theme.background-alt} ctermfg=${toString theme.error}
        hi Warning      ctermbg=${toString theme.background-alt} ctermfg=${toString theme.warning}
        hi Todo         ctermbg=${toString theme.background-alt} ctermfg=${toString theme.info}
        hi ErrorMsg     ctermbg=NONE ctermfg=${toString theme.error}
        hi WarningMsg   ctermbg=NONE ctermfg=${toString theme.warning}
        hi InfoMsg      ctermbg=NONE ctermfg=${toString theme.info}
        hi! link ModeMsg InfoMsg
        hi! link MoreMsg InfoMsg
        hi! link AleErrorSign ErrorMsg
        hi! link AleWarningSign WarningMsg
        hi! link AleInfoSign InfoMsg
        hi! link SpellCap Todo
        hi! link SpellRare Warning
        hi! link SpellBad Error
        hi DiffAdd    ctermbg=NONE ctermfg=${toString theme.diff-add}
        hi DiffChange ctermbg=NONE ctermfg=${toString theme.diff-change}
        hi DiffDelete ctermbg=NONE ctermfg=${toString theme.diff-remove}
        hi DiffText   ctermbg=${toString theme.background-alt} ctermfg=${toString theme.diff-change} cterm=NONE
        hi! link GitGutterAdd DiffAdd
        hi! link GitGutterChange DiffChange
        hi! link GitGutterAddDelete DiffDelete
        hi! link GitGutterChangeDelete DiffDelete
        hi! link GitGutterDelete DiffDelete
        hi! link diffAdded DiffAdd
        hi! link diffRemoved DiffDelete
        hi! link diffChanged DiffChange
        hi gitcommitSelectedType ctermbg=NONE ctermfg=${toString theme.staged} cterm=NONE
        hi! link gitcommitDiscardedType DiffChange
        hi! link gitcommitUntrackedType DiffDelete
        hi! link gitcommitSelectedFile gitcommitSelectedType
        hi! link gitcommitDiscardedFile gitcommitDiscardedType
        hi! link gitcommitUntrackedFile gitcommitUntrackedType
        hi gitcommitBranch ctermbg=NONE ctermfg=${toString theme.currentBranch}
      '';
      plug.plugins = let
        vim-gdscript3 = pkgs.vimUtils.buildVimPlugin {
          name = "vim-gdscript3";
          src = pkgs.fetchFromGitHub {
            owner = "calviken";
            repo = "vim-gdscript3";
            rev = "master";
            sha256 = "0b9ghcjiwkkldvg1zwyhi8163dcbg6sh64zrd8nk081qlbrs4shb";
          };
        };
        vim-mucomplete = pkgs.vimUtils.buildVimPlugin {
          name = "vim-mucomplete";
          src = pkgs.fetchFromGitHub {
            owner = "lifepillar";
            repo = "vim-mucomplete";
            rev = "v1.4.0";
            sha256 = "0rl4ijz2asyrhr2s72j1y06js0yizzir414q6fznvgvmic4wjcj9";
          };
        };
        vim-auto-origami = pkgs.vimUtils.buildVimPlugin {
          name = "vim-auto-origami";
          src = pkgs.fetchFromGitHub {
            owner = "benknoble";
            repo = "vim-auto-origami";
            rev = "v1.0.0";
            sha256 = "1zlrafb4lp7rw8kdnaw6spiys6xi3ayamfyzzp0wzl5jy7mv2ayw";
          };
        }; in
      with pkgs.vimPlugins; [
        vim-sensible vim-polyglot vim-nix editorconfig-vim ale fugitive gitgutter vim-gutentags (vim-mucomplete) (vim-auto-origami) (vim-gdscript3)
      ];
    };
  });
  in
  {
    variables = {
      EDITOR = "vim";
    };
    systemPackages = [ pkgs.nvi pkgs.universal-ctags (system_vim) ];
  };
}
