{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fzf
  ];
  programs.zsh.enable = true;
  programs.zsh.autosuggestions = {
    enable = true;
    strategy = "match_prev_cmd";
    highlightStyle = "fg=8";
  };
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "colored-man-pages"
    ];
    theme = "starlight";
    customPkgs = 
      let
        zsh-starlight-theme = with pkgs; stdenv.mkDerivation rec {
          name = "zsh-starlight-theme-v1.9";
          src = fetchFromGitHub {
            owner = "isaacwhanson";
            repo = "zsh-starlight-theme";
            rev = "v1.9";
            sha256 = "0g2nnggz8kb3mimj8chh2bb70vdh49jfp0fr381cb2p30iw7n1x7";
          };
            
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/share/zsh/themes
            cp themes/starlight.zsh-theme $out/share/zsh/themes/
          '';
        };
      in
      [ (zsh-starlight-theme) pkgs.zsh-completions pkgs.nix-zsh-completions ];
  };
  programs.zsh.syntaxHighlighting = {
    enable = true;
    highlighters = [ "main" "brackets" "cursor" "root" "line" ];
  };
  environment.etc.dircolors = {
    text = ''
      TERM Eterm
      TERM ansi
      TERM color-xterm
      TERM con132x25
      TERM con132x30
      TERM con132x43
      TERM con132x60
      TERM con80x25
      TERM con80x28
      TERM con80x30
      TERM con80x43
      TERM con80x50
      TERM con80x60
      TERM cons25
      TERM console
      TERM cygwin
      TERM dtterm
      TERM eterm-color
      TERM gnome
      TERM gnome-256color
      TERM hurd
      TERM jfbterm
      TERM konsole
      TERM kterm
      TERM linux
      TERM linux-c
      TERM mach-color
      TERM mach-gnu-color
      TERM mlterm
      TERM putty
      TERM putty-256color
      TERM rxvt
      TERM rxvt-256color
      TERM rxvt-cygwin
      TERM rxvt-cygwin-native
      TERM rxvt-unicode
      TERM rxvt-unicode-256color
      TERM rxvt-unicode256
      TERM screen
      TERM screen-256color
      TERM screen-256color-bce
      TERM screen-bce
      TERM screen-w
      TERM screen.Eterm
      TERM screen.rxvt
      TERM screen.linux
      TERM screen.xterm
      TERM st
      TERM st-256color
      TERM terminator
      TERM vt100
      TERM xterm
      TERM xterm-16color
      TERM xterm-256color
      TERM xterm-88color
      TERM xterm-color
      TERM xterm-debian
      TERM xterm-termite
      # Below are the color init strings for the basic file types. A color init
      # string consists of one or more of the following numeric codes:
      # Attribute codes:
      # 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
      # Text color codes:
      # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
      # Background color codes:
      # 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
      #NORMAL 00 # no color code at all
      #FILE 00 # regular file: use no color at all
      RESET 0 # reset to "normal" color
      DIR 0;34 # directory
      LINK target #0;36 # symbolic link. (If you set this to 'target' instead of a
      # numerical value, the color is as for the file pointed to.)
      MULTIHARDLINK 00 # regular file with more than one link
      FIFO 00;33 # pipe
      SOCK 0;35 # socket
      DOOR 0;35 # door
      BLK 0;33 # block device driver
      CHR 0;33 # character device driver
      ORPHAN 00;31 # symlink to nonexistent file, or non-stat'able file ...
      MISSING 1;30 # ... and the files they point to
      SETUID 4;31 # file that is setuid (u+s)
      SETGID 4;0;33 # file that is setgid (g+s)
      CAPABILITY 4;0;35 # file with capability
      STICKY_OTHER_WRITABLE 0;7;4;32 # dir that is sticky and other-writable (+t,o+w)
      OTHER_WRITABLE 0;7;32 # dir that is other-writable (o+w) and not sticky
      STICKY 0;4;31 # dir with the sticky bit set (+t) and not other-writable
      # This is for files with execute permission:
      EXEC 1;32
      # List any file extensions like '.gz' or '.tar' that you would like ls
      # to colorize below. Put the extension, a space, and the color init string.
      # (and any comments you want to add after a '#')
      # If you use DOS-style suffixes, you may want to uncomment the following:
      .cmd 0;32 # executables (bright green)
      .exe 0;32
      .com 0;32
      .btm 0;32
      .bat 0;32
      # Or if you want to colorize scripts even if they do not have the
      # executable bit actually set.
      .sh 00;32
      .csh 00;32
      .tcsh 00;32

      # archives or compressed (bright red)
      .tar 1;31
      .tgz 1;31
      .arc 1;31
      .arj 1;31
      .taz 1;31
      .lha 1;31
      .lz4 1;31
      .lzh 1;31
      .lzma 1;31
      .tlz 1;31
      .txz 1;31
      .tzo 1;31
      .t7z 1;31
      .zip 1;31
      .z 1;31
      .Z 1;31
      .dz 1;31
      .gz 1;31
      .lrz 1;31
      .lz 1;31
      .lzo 1;31
      .xz 1;31
      .bz2 1;31
      .bz 1;31
      .tbz 1;31
      .tbz2 1;31
      .tz 1;31
      .deb 1;31
      .rpm 1;31
      .jar 1;31
      .war 1;31
      .ear 1;31
      .sar 1;31
      .rar 1;31
      .alz 1;31
      .ace 1;31
      .zoo 1;31
      .cpio 1;31
      .7z 1;31
      .rz 1;31
      .cab 1;31
      # image formats
      .jpg 0;35
      .jpeg 0;35
      .gif 0;35
      .bmp 0;35
      .pbm 0;35
      .pgm 0;35
      .ppm 0;35
      .tga 0;35
      .xbm 0;35
      .xpm 0;35
      .tif 0;35
      .tiff 0;35
      .png 0;35
      .svg 0;35
      .svgz 0;35
      .mng 0;35
      .pcx 0;35
      .mov 0;35
      .mpg 0;35
      .mpeg 0;35
      .m2v 0;35
      .mkv 0;35
      .webm 0;35
      .ogm 0;35
      .mp4 0;35
      .m4v 0;35
      .mp4v 0;35
      .vob 0;35
      .qt 0;35
      .nuv 0;35
      .wmv 0;35
      .asf 0;35
      .rm 0;35
      .rmvb 0;35
      .flc 0;35
      .avi 0;35
      .fli 0;35
      .flv 0;35
      .gl 0;35
      .dl 0;35
      .xcf 0;35
      .xwd 0;35
      .yuv 0;35
      .cgm 0;35
      .emf 0;35
      # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
      .ogv 0;35
      .ogx 0;35
      # audio formats
      .aac 00;36
      .au 00;36
      .flac 00;36
      .m4a 00;36
      .mid 00;36
      .midi 00;36
      .mka 00;36
      .mp3 00;36
      .mpc 00;36
      .ogg 00;36
      .ra 00;36
      .wav 00;36
      # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
      .oga 00;36
      .opus 00;36
      .spx 00;36
      .xspf 00;36

      # encrypted/key formats
      .gpg  0;33
      .pgp  0;33
      .pub  0;33
      .crt  0;33
      .pem  0;33
      .asc  0;33
      .3des 0;33
      .aes  0;33
      .enc  0;33
      .sig  0;33
      *key  0;33

      # documents
      .pdf   0;35
      .doc   0;35
      .docx  0;35
      .xps   0;35
      .xpsx  0;35
      .odg   0;35
      .odt   0;35
      .odf   0;35
      .xls   0;35
      .xlsx  0;35
      .dia   0;35
      .rtf   0;35
      .dot   0;35
      .dotx  0;35
      .ppt   0;35
      .pptx  0;35
      .fla   0;35
      .psd   0;35

      # source code files
      .c    0;32
      .h    0;32
      .java 0;32
      .js   0;32
      .jsx  0;32
      .vim  0;32
      .py   0;32

      # data files
      .json         0;33
      .xml          0;33
      .iml          0;33
      .properties   0;33
      .yml          0;33

      # txt files
      .txt     1;36
      .TXT     1;36
      .log     1;36

      # readme, etc
      .md        1;37
      *README    1;37
      *README.TXT 1;37
      *README.txt 1;37

      # html
      .html   0;35
      .htm    0;35
      .css    0;35
      .less   0;35

      # other
      *.pid         1;36
      *desktop.ini  1;36
      *Desktop.ini  1;36
      *~            1;36
      .ICEauthority 1;36
      .Xauthority   1;36
      .xsession-errors 1;36
      .old          1;36
      .hidden       1;36
    '';
  };
  environment.interactiveShellInit = ''
    bindkey -v
    # spellcheck commands
    setopt correct
    # backspace
    bindkey -a '^?' vi-backward-delete-char
    # home
    bindkey -a '\e[1~' vi-first-non-blank
    bindkey '\e[1~' vi-first-non-blank
    # insert
    bindkey -a '\e[2~' vi-insert
    bindkey '\e[2~' vi-insert # noop?
    # delete
    bindkey '\e[3~' vi-delete-char
    bindkey -a '\e[3~' vi-delete-char
    # end
    bindkey -a '\e[4~'  vi-end-of-line
    bindkey '\e[4~'  vi-end-of-line
    bindkey  "''${terminfo[khome]}" vi-beginning-of-line
    bindkey -a "''${terminfo[khome]}" vi-beginning-of-line
    bindkey  "''${terminfo[kend]}" vi-end-of-line
    bindkey -a "''${terminfo[kend]}" vi-end-of-line
    # complete word
    bindkey '^w' vi-forward-word
  '';
  programs.zsh.loginShellInit = ''
    eval `dircolors -b /etc/dircolors`
  '';
  programs.zsh.promptInit = ''
    bindkey -v
    # shorter delay on cmd-mode
    export KEYTIMEOUT=1
    zle-line-init() {
      typeset -g __prompt_status="$?"
    }
    zle-keymap-select () {
      if [ ! "$TERM" = "linux" ]; then
        if [ $KEYMAP = vicmd ]; then
          echo -ne "\e[1 q"
        else
          echo -ne "\e[3 q"
        fi
      fi
      () { return $__prompt_status }
      zle reset-prompt
    }
    zle -N zle-keymap-select
    zle -N zle-line-init

    autoload -Uz run-help
    unalias run-help
    alias help=run-help

    # better auto-suggest
    my-autosuggest-accept() {
      zle autosuggest-accept
      zle redisplay
    }
    zle -N my-autosuggest-accept
    bindkey '^ ' my-autosuggest-accept
    ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=my-autosuggest-accept
    ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=vi-forward-char
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=""

    #export ZSH_HIGHLIGHT_STYLES[cursor]=
    export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bg=8'
    export ZSH_HIGHLIGHT_STYLES[path]='fg=blue'
    export ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue'
    export ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
    export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=white,underline'
    export ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
    export ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
    export ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
    export ZSH_HIGHLIGHT_STYLES[builtin]='fg=magenta,bold'
    export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta,bold,underline'
    export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta,bold'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=blue'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=green'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=cyan'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=cyan'
    export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan,bold'
    export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
    
    # fzf with tmux
    export FZF_TMUX=1
    export FZF_DEFAULT_COMMAND='ag -f -g "" --hidden --depth 16 --ignore dosdevices'
    export FZF_DEFAULT_OPTS='-m --ansi --color=16,bg:-1,bg+:-1 --tac'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find -L . -maxdepth 16 -type d 2>/dev/null"
    source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    source ${pkgs.fzf}/share/fzf/completion.zsh

    export LESS="-erFX"

    # some aliases
    alias l='ls -hF'
    alias la='ls -AhF'
    alias ll='ls -l'
    alias cp='cp --reflink=auto'
    alias xz='xz --threads=0'
    '';
}
