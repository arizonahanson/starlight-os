{ config, pkgs, ... }:

{
  environment = let system_vim = (pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        " temp cache directory
        let g:vimcache='/tmp/.vim-'.$USER.'/'
        call mkdir(g:vimcache, 'p', 0700)
        " no startup message
        set shortmess+=I
        " recursive pathfinding
        set path+=**
        " visual theme
        let g:gitgutter_override_sign_column_highlight=0
        let g:gitgutter_sign_modified=' '
        let g:gitgutter_sign_modified_removed=' '
        let g:gitgutter_sign_added=' '
        let g:gitgutter_sign_removed=' '
        let g:ale_sign_error=' '
        let g:ale_sign_warning=' '
        let g:ale_sign_info=' '
        set updatetime=1000
        set guicursor=n-v-c-sm:block-blinkwait500-blinkon500-blinkoff500,i-ci-ve:ver25-blinkwait500-blinkon500-blinkoff500,r-cr-o:hor20-blinkwait500-blinkon500-blinkoff500
        set statusline=%<\ %f\ %m%r%=%y\ %-2.(%l,%c%V%)\ 
        " swapfile
        set swapfile
        let &directory=g:vimcache.'swap//'
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
        " keep buffers, large shada, relocate shada file
        let shada_file=g:vimcache.'shada'
        let &shada="%,!,'1000,s1024,n".shada_file
        " return to last edit position when opening files
        autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
        " ctags
        let g:gutentags_cache_dir=g:vimcache.'ctags//'
        let g:gutentags_exclude_filetypes=["gitcommit", "gitrebase"]
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
        " turn on completion
        let g:mucomplete#enable_auto_at_startup = 1
        set completeopt+=menuone
        set completeopt+=noselect
        let g:mucomplete#no_mappings = 1
        autocmd FileType *
          \ if &omnifunc == "" |
          \   setlocal omnifunc=syntaxcomplete#Complete |
          \ endif
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
        " turn-on numbers
        set number
        " activate spell check for some types
        autocmd FileType gitcommit set spell spelllang=en_us
        autocmd FileType gitcommit set nonumber
        autocmd FileType markdown set spell spelllang=en_us
        autocmd FileType markdown set nonumber
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
        " colorscheme
        colorscheme starlight
      '';
      plug.plugins = let
        vim-mucomplete = pkgs.vimUtils.buildVimPlugin {
          name = "vim-mucomplete";
          src = pkgs.fetchFromGitHub {
            owner = "lifepillar";
            repo = "vim-mucomplete";
            rev = "v1.4.0";
            sha256 = "0rl4ijz2asyrhr2s72j1y06js0yizzir414q6fznvgvmic4wjcj9";
          };
        };
        vim-starlight-theme = pkgs.vimUtils.buildVimPlugin {
          name = "vim-starlight-theme";
          src = pkgs.fetchFromGitHub {
            owner = "isaacwhanson";
            repo = "vim-starlight-theme";
            rev = "v0.6";
            sha256 = "19h82bzjj0k6l2ma4s9p8g60vb7y5fc1s6p06vl772z3im8vfrs9";
          };
        }; in
      with pkgs.vimPlugins; [
        (vim-starlight-theme) vim-sensible editorconfig-vim fugitive gitgutter vim-polyglot vim-nix ale (vim-mucomplete) vim-gutentags
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
