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
        let g:gitgutter_sign_modified=''
        let g:gitgutter_sign_modified_removed=''
        let g:gitgutter_sign_added=''
        let g:gitgutter_sign_removed=''
        let g:ale_sign_error=''
        let g:ale_sign_warning=''
        let g:ale_sign_info=''
        set updatetime=1000
        set guicursor=n-v-c-sm:block-blinkwait500-blinkon500-blinkoff500,i-ci-ve:ver25-blinkwait500-blinkon500-blinkoff500,r-cr-o:hor20-blinkwait500-blinkon500-blinkoff500
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
        let g:deoplete#enable_at_startup = 1
        call deoplete#custom#option({
        \ 'auto_complete_delay': 500,
        \ 'ignore_case': v:true
        \ })
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
        " turn-on numbers
        autocmd FileType go set number
        autocmd FileType javascript set number
        autocmd FileType nix set number
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
        " do not pollute with ctags
        let g:gutentags_cache_dir='/tmp/.gutentags-' . $USER
        let g:gutentags_exclude_filetypes=["gitcommit", "gitrebase"]
        " colorscheme
        colorscheme starlight
      '';
      plug.plugins = let vim-starlight-theme = pkgs.vimUtils.buildVimPlugin {
        name = "vim-starlight-theme";
        src = pkgs.fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "vim-starlight-theme";
          rev = "v0.3";
          sha256 = "1nq5wrwm6wr0kgk8cyh3jpx3y7rs8m4j91y5vcjwid2np2yr04zj";
        };
      }; in
      with pkgs.vimPlugins; [
        (vim-starlight-theme) vim-sensible editorconfig-vim fugitive gitgutter vim-polyglot vim-nix ale neco-syntax deoplete-nvim vim-gutentags
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
