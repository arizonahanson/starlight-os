{ config, pkgs, ... }:

{
  environment = let
    system_vim = (
      pkgs.vim_configurable.customize {
        name = "vim";
        vimrcConfig = let
          cfg = config.starlight;
        in {
            beforePlugins = ''
              let g:ale_cache_executable_check_failures=1
              let g:ale_lint_delay=500
              let g:ale_sign_error=' '
              let g:ale_sign_warning=' '
              let g:ale_sign_info=' '
              let g:gitgutter_override_sign_column_highlight=0
              let g:gitgutter_sign_priority=1
              let g:gitgutter_sign_allow_clobber=0
              let g:gitgutter_sign_added=' '
              let g:gitgutter_sign_modified=' '
              let g:gitgutter_sign_modified_removed=' '
              let g:gitgutter_sign_removed=' '
              let g:gitgutter_sign_removed_first_line=' '
              let g:vimcache='/tmp/.vim-'.$USER.'/'
              let g:gutentags_cache_dir=g:vimcache.'ctags//'
              let g:gutentags_exclude_filetypes=["gitcommit", "gitrebase"]
              let g:mucomplete#completion_delay=500
              let g:mucomplete#enable_auto_at_startup=1
              let g:mucomplete#no_mappings=1
            '';
            customRC = ''
              "--- moving around, searching and patterns
              set whichwrap+=<,>,h,l
              set path+=**
              set ignorecase
              set smartcase
              "--- displaying text
              set cmdheight=1
              set scrolloff=6
              set number
              set numberwidth=1
              set lazyredraw
              set fillchars=vert:│,fold:╌
              autocmd FileType gitcommit setlocal nonumber
              autocmd FileType markdown setlocal nonumber
              "--- syntax, highlighting and spelling
              set background=dark
              set hlsearch
              set cursorline
              autocmd FileType gitcommit setlocal spell spelllang=en_us
              autocmd FileType markdown setlocal spell spelllang=en_us
              highlight Normal ctermbg=NONE ctermfg=${toString cfg.theme.foreground} cterm=NONE
              highlight Noise ctermbg=NONE ctermfg=${toString cfg.theme.foreground-alt} cterm=NONE
              highlight Identifier ctermbg=NONE ctermfg=${toString cfg.theme.substitution} cterm=NONE
              highlight Comment ctermbg=NONE ctermfg=${toString cfg.theme.background-alt} cterm=NONE
              highlight CursorLine ctermbg=NONE ctermfg=NONE cterm=NONE
              highlight Visual ctermbg=${toString cfg.theme.background-alt} cterm=NONE
              highlight StatusLine ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.foreground} cterm=NONE
              highlight StatusLineNC ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.foreground-alt} cterm=NONE
              highlight WildMenu ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.select} cterm=NONE
              highlight PmenuThumb ctermfg=${toString cfg.theme.foreground-alt}
              highlight Underlined ctermbg=NONE ctermfg=${toString cfg.theme.path} cterm=underline
              highlight IncSearch ctermbg=NONE ctermfg=${toString cfg.theme.match} cterm=underline
              highlight Search ctermbg=NONE ctermfg=${toString cfg.theme.match} cterm=NONE
              highlight String ctermfg=${toString cfg.theme.string}
              highlight Character ctermfg=${toString cfg.theme.character}
              highlight Number ctermfg=${toString cfg.theme.number}
              highlight Constant ctermfg=${toString cfg.theme.constant}
              highlight Function ctermfg=${toString cfg.theme.function}
              highlight Type ctermfg=${toString cfg.theme.type}
              highlight Statement ctermfg=${toString cfg.theme.statement}
              highlight Keyword ctermfg=${toString cfg.theme.keyword}
              highlight Error ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.error}
              highlight Warning ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.warning}
              highlight Todo ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.info}
              highlight ErrorMsg ctermbg=NONE ctermfg=${toString cfg.theme.error}
              highlight WarningMsg ctermbg=NONE ctermfg=${toString cfg.theme.warning}
              highlight InfoMsg ctermbg=NONE ctermfg=${toString cfg.theme.info}
              highlight DiffAdd ctermbg=NONE ctermfg=${toString cfg.theme.diff-add}
              highlight DiffChange ctermbg=NONE ctermfg=${toString cfg.theme.diff-change}
              highlight DiffDelete ctermbg=NONE ctermfg=${toString cfg.theme.diff-remove}
              highlight DiffText ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.diff-change} cterm=NONE
              highlight gitcommitSelectedType ctermbg=NONE ctermfg=${toString cfg.theme.staged} cterm=NONE
              highlight gitcommitBranch ctermbg=NONE ctermfg=${toString cfg.theme.currentBranch}
              highlight! link MatchParen Search
              highlight! link LineNr Comment
              highlight! link CursorLineNr Noise
              highlight! link SpecialComment Noise
              highlight! link Folded Noise
              highlight! link FoldColumn LineNr
              highlight! link SignColumn CursorLine
              highlight! link TabLine Comment
              highlight! link TabLineSel StatusLine
              highlight! link TabLineFill CursorLine
              highlight! link Pmenu StatusLineNC
              highlight! link PmenuSbar StatusLineNC
              highlight! link PmenuSel StatusLine
              highlight! link Debug SpecialComment
              highlight! link Ignore Comment
              highlight! link VertSplit LineNr
              highlight! link NonText Comment
              highlight! link Special Character
              highlight! link Integer Number
              highlight! link Boolean Constant
              highlight! link Question Function
              highlight! link Include Type
              highlight! link Exception Keyword
              highlight! link Operator Keyword
              highlight! link Repeat Statement
              highlight! link StorageClass Statement
              highlight! link Structure Statement
              highlight! link Typedef Statement
              highlight! link PreProc Statement
              highlight! link Label Statement
              highlight! link ModeMsg InfoMsg
              highlight! link MoreMsg InfoMsg
              highlight! link SpellCap Todo
              highlight! link SpellRare Warning
              highlight! link SpellBad Error
              highlight! link diffLine CursorLineNr
              highlight! link diffFile LineNr
              highlight! link diffIndexLine diffFile
              highlight! link diffSubname Normal
              highlight! link diffAdded DiffAdd
              highlight! link diffRemoved DiffDelete
              highlight! link diffChanged DiffChange
              highlight! link gitcommitHeader Comment
              highlight! link gitcommitSummary Normal
              highlight! link gitcommitDiscardedType DiffChange
              highlight! link gitcommitUntrackedType DiffDelete
              highlight! link gitcommitSelectedFile gitcommitSelectedType
              highlight! link gitcommitDiscardedFile gitcommitDiscardedType
              highlight! link gitcommitUntrackedFile gitcommitUntrackedType
              highlight! link AleErrorSign ErrorMsg
              highlight! link AleWarningSign WarningMsg
              highlight! link AleInfoSign InfoMsg
              highlight! link GitGutterAdd DiffAdd
              highlight! link GitGutterChange DiffChange
              highlight! link GitGutterAddDelete DiffDelete
              highlight! link GitGutterChangeDelete DiffDelete
              highlight! link GitGutterDelete DiffDelete
              highlight! link shOption Constant
              highlight! link shShellVariables Identifier
              highlight! link zshTypes Statement
              highlight! link zshDereferencing Identifier
              highlight! link jsNull Constant
              highlight! link jsThis Constant
              highlight! link goBuiltins Function
              highlight! link csBraces Noise
              highlight! link csLogicSymbols Operator
              highlight User1 ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.info} cterm=NONE
              highlight User2 ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.diff-change} cterm=NONE
              highlight User3 ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.currentBranch} cterm=NONE
              highlight User4 ctermbg=${toString cfg.theme.background-alt} ctermfg=${toString cfg.theme.number} cterm=NONE
              "--- multiple windows
              set statusline=%<\ %f\ %1*%r%*%2*%(%m\ %)%*%=%3*%{FugitiveHead()}%*\ %l,%c%V\ %4*%B%*\ 
              set hidden
              set switchbuf=useopen,usetab,newtab
              "--- multiple tab pages
              set showtabline=1
              function! Tabline()
                let s='''
                for i in range(tabpagenr('$'))
                  let tab=i + 1
                  let winnr=tabpagewinnr(tab)
                  let buflist=tabpagebuflist(tab)
                  let bufnr=buflist[winnr - 1]
                  let bufname=bufname(bufnr)
                  let s .= '%' . tab . 'T'
                  let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
                  let s .= (bufname != ''' ? ' '.fnamemodify(bufname, ':t').' ' : '[No Name] ')
                endfor
                let s .= '%#TabLineFill#'
                return s
              endfunction
              set tabline=%!Tabline()
              "--- terminal
              set guicursor=n-v-c-sm:block-blinkwait500-blinkon500-blinkoff500,i-ci-ve:ver25-blinkwait500-blinkon500-blinkoff500,r-cr-o:hor20-blinkwait500-blinkon500-blinkoff500
              let &t_SI="\e[${toString cfg.insertCursor} q"
              let &t_SR="\e[${toString cfg.replaceCursor} q"
              let &t_EI="\e[${toString cfg.commandCursor} q"
              "--- messages and info
              set shortmess+=I
              set shortmess+=c
              set noerrorbells
              set novisualbell
              set belloff+=ctrlg
              "--- editing text
              set completeopt=menu,menuone,preview,noinsert,noselect
              set showmatch
              set undofile
              let &undodir=g:vimcache.'undo//'
              call mkdir(&undodir, 'p', 0700)
              autocmd FileType *
                \ if &omnifunc == "" || &omnifunc == "styledcomplete#CompleteSC" |
                \   setlocal omnifunc=syntaxcomplete#Complete |
                \ endif
              "--- folding
              augroup autofold
                au!
                au BufReadPost * silent! loadview
                au BufReadPost * if auto_origami#Foldcolumn() <= 0 | setlocal foldmethod=indent | endif
                au CursorHold,BufWinEnter,WinEnter * let &foldcolumn=auto_origami#Foldcolumn()
                au BufWinEnter * if &foldmethod == "indent" | setlocal foldmethod=manual | silent! :%foldopen! | endif
                au BufWinLeave * silent! mkview!
              augroup END
              autocmd FileType gitcommit setlocal foldmethod=syntax
              "--- diff mode
              set diffopt=filler,vertical
              "--- mapping
              set notimeout
              set ttimeout
              "--- reading and writing files
              set fileformats=unix,dos,mac
              set nobackup
              set writebackup
              set backupcopy=auto
              let &backupdir=g:vimcache.'backup//'
              call mkdir(&backupdir, 'p', 0700)
              "--- the swap file
              set swapfile
              set updatetime=500
              let &directory=g:vimcache.'swap//'
              call mkdir(&directory, 'p', 0700)
              "--- command line editing
              set wildmode=longest:full,full
              set wildignore=*.o,*~,*.pyc,*.so,*.class,.DS_Store
              "--- multi-byte characters
              set encoding=utf-8
              set fileencoding=utf-8
              set termencoding=utf-8
              "--- various
              let &viminfo="%,!,'1000,s1024,n".g:vimcache.'viminfo'
              set viewoptions=folds,cursor
              let &viewdir=g:vimcache.'view//'
              call mkdir(&viewdir, 'p', 0700)
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
              };
            in
              with pkgs.vimPlugins; [
                vim-sensible
                vim-polyglot
                vim-nix
                (vim-gdscript3)
                editorconfig-vim
                (vim-auto-origami)
                fugitive
                gitgutter
                vim-gutentags
                ale
                (vim-mucomplete)
              ];
          };
      }
    );
  in
    {
      variables = {
        EDITOR = "vim";
      };
      systemPackages = [ pkgs.nvi pkgs.universal-ctags (system_vim) ];
    };
}
