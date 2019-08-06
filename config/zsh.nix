{ config, lib, pkgs, ... }:

with lib;

{
  config = let cfg = config.starlight; in {
    programs.zsh.enable = true;
    programs.zsh.autosuggestions = {
      enable = true;
      strategy = "match_prev_cmd";
      highlightStyle = "fg=${cfg.theme.background-alt}";
    };
    programs.zsh.syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "cursor" "root" "line" ];
    };
    programs.zsh.ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "colored-man-pages"
      ];
      theme = "starlight";
      cacheDir = "/tmp/.ohmyzsh-$USER";
      customPkgs = 
        let
          zsh-starlight-theme = with pkgs; stdenv.mkDerivation rec {
            name = "zsh-starlight-theme";
            src = fetchFromGitHub {
              owner = "isaacwhanson";
              repo = "zsh-starlight-theme";
              rev = "v2.4";
              sha256 = "0japff6bs7ar6rlid1p5rswpha6rb0dy676f9mij5mv0ih8asb4m";
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
    # zprofile (once, before zshrc)
    programs.zsh.loginShellInit = ''
      eval `dircolors -b /etc/dircolors`
    '';
    # zshrc (start)
    programs.zsh.enableGlobalCompInit = false;
    environment.interactiveShellInit = ''
      # keep zcompdump in tmpfs
      mkdir -p "/tmp/.zcompdump-''${USER}"
      autoload -U compinit && compinit -d "/tmp/.zcompdump-''${USER}/zcompdump"
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
    # zshrc (end)
    programs.zsh.promptInit = ''
      # vi-like editing
      bindkey -v
      # save prompt status
      zle-line-init() {
        typeset -g __prompt_status="$?"
      }
      zle -N zle-line-init
      # cursor shows mode
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

      # better 'help'
      autoload -Uz run-help
      unalias run-help
      alias help=run-help

      bindkey '^ ' autosuggest-accept
      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=vi-forward-char
      #ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=""

      export ZSH_HIGHLIGHT_STYLES[cursor]=fg=yellow
      export ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=yellow'
      export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
      export ZSH_HIGHLIGHT_STYLES[path]='fg=${cfg.theme.path}'
      export ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue,bold'
      export ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
      export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
      export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green,bold'
      export ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=cyan'
      export ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=yellow,bold'
      export ZSH_HIGHLIGHT_STYLES[alias]='fg=yellow,bold'
      export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=yellow,bold'
      export ZSH_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
      export ZSH_HIGHLIGHT_STYLES[precommand]='fg=red,bold'
      export ZSH_HIGHLIGHT_STYLES[command]='fg=yellow'
      export ZSH_HIGHLIGHT_STYLES[builtin]='fg=magenta'
      export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta,bold'
      export ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta,bold'
      export ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta,underline'
      export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta,bold'
      export ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta,bold'
      export ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=magenta'
      export ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=blue,bold'
      export ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=blue'
      export ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
      export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
      export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan,bold'
      
      # fzf with tmux
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} ma=100\;97

      # last to pickup other zsh-widgets
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    '';
    programs.zsh.shellAliases = with pkgs; {
      l = "ls -hF";
      la = "ls -AhF";
      ll = "ls -lAhF";
      cp = "cp --reflink=auto";
      xz = "xz --threads=0";
      ag = "${pkgs.ag}/bin/ag --color-line-number '1;30' --color-path '0;34' --color-match '100;97'";
    };
    environment.variables = {
      # shorter delay on cmd-mode
      KEYTIMEOUT = "1";
      LESS = "-erFX";
      FZF_TMUX = "1";
      FZF_DEFAULT_COMMAND = "ag -f -g '' --hidden --depth 16 --ignore dosdevices";
      FZF_CTRL_T_COMMAND = "ag -f -g '' --hidden --depth 16 --ignore dosdevices";
      FZF_DEFAULT_OPTS = "-m --ansi --color=16,bg:-1,bg+:-1 --tac";
      FZF_ALT_C_COMMAND = "find -L . -maxdepth 16 -type d 2>/dev/null";
      GREP_COLORS="mt=100;97:sl=:cx=:fn=34:ln=01;30:bn=32:se=37";
    };
    environment.etc.dircolors = {
      text = ''
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
        TERM gnome
        TERM gnome-256color
        TERM linux
        TERM linux-c
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
        TERM xterm-color
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
        SOCK 1;35 # socket
        DOOR 0;35 # door
        FIFO 1;33 # pipe
        BLK 1;32 # block device driver
        CHR 0;32 # character device driver
        ORPHAN 0;31 # symlink to nonexistent file, or non-stat'able file ...
        MISSING 1;30 # ... and the files they point to
        SETUID 1;4;31 # file that is setuid (u+s)
        SETGID 4;1;33 # file that is setgid (g+s)
        CAPABILITY 4;1;35 # file with capability
        STICKY_OTHER_WRITABLE 0;4;34 # dir that is sticky and other-writable (+t,o+w)
        OTHER_WRITABLE 0;34 # dir that is other-writable (o+w) and not sticky
        STICKY 1;4;34 # dir with the sticky bit set (+t) and not other-writable
        # This is for files with execute permission:
        EXEC 0;33
        # List any file extensions like '.gz' or '.tar' that you would like ls
        # to colorize below. Put the extension, a space, and the color init string.
        # (and any comments you want to add after a '#')
        # If you use DOS-style suffixes, you may want to uncomment the following:
        .cmd 0;33 # executables
        .exe 0;33
        .com 0;33
        .btm 0;33
        .bat 0;33
        # Or if you want to colorize scripts even if they do not have the
        # executable bit actually set.
        .sh 0;33
        .csh 0;33
        .tcsh 0;33

        # archives or compressed
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
        .jpg 1;35
        .jpeg 1;35
        .gif 1;35
        .bmp 1;35
        .pbm 1;35
        .pgm 1;35
        .ppm 1;35
        .tga 1;35
        .xbm 1;35
        .xpm 1;35
        .tif 1;35
        .tiff 1;35
        .png 1;35
        .svg 1;35
        .svgz 1;35
        .mng 1;35
        .pcx 1;35
        .mov 1;35
        .mpg 1;35
        .mpeg 1;35
        .m2v 1;35
        .mkv 1;35
        .webm 1;35
        .ogm 1;35
        .mp4 1;35
        .m4v 1;35
        .mp4v 1;35
        .vob 1;35
        .qt 1;35
        .nuv 1;35
        .wmv 1;35
        .asf 1;35
        .rm 1;35
        .rmvb 1;35
        .flc 1;35
        .avi 1;35
        .fli 1;35
        .flv 1;35
        .gl 1;35
        .dl 1;35
        .xcf 1;35
        .xwd 1;35
        .yuv 1;35
        .cgm 1;35
        .emf 1;35
        # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
        .ogv 1;35
        .ogx 1;35
        # audio formats
        .aac 1;36
        .au 1;36
        .flac 1;36
        .m4a 1;36
        .mid 1;36
        .midi 1;36
        .mka 1;36
        .mp3 1;36
        .mpc 1;36
        .ogg 1;36
        .ra 1;36
        .wav 1;36
        # http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions
        .oga 1;36
        .opus 1;36
        .spx 1;36
        .xspf 1;36

        # encrypted/key formats
        .gpg  1;33
        .pgp  1;33
        .pub  1;33
        .crt  1;33
        .pem  1;33
        .asc  1;33
        .3des 1;33
        .aes  1;33
        .enc  1;33
        .sig  1;33
        *key  1;33

        # documents
        .pdf   1;35
        .doc   1;35
        .docx  1;35
        .xps   1;35
        .xpsx  1;35
        .odg   1;35
        .odt   1;35
        .odf   1;35
        .xls   1;35
        .xlsx  1;35
        .dia   1;35
        .rtf   1;35
        .dot   1;35
        .dotx  1;35
        .ppt   1;35
        .pptx  1;35
        .fla   1;35
        .psd   1;35

        # source code files
        .c    1;33
        .h    1;33
        .java 1;33
        .js   1;33
        .jsx  1;33
        .vim  1;33
        .py   1;33
        .go   1;33
        .nix  1;33

        # data files
        .json         1;32
        .xml          1;32
        .iml          1;32
        .properties   1;32
        .yml          1;32
        .yaml         1;32
        .toml         1;32

        # txt files
        .txt     0;37
        .TXT     0;37
        .log     0;37

        # readme, etc
        .md        1;37
        *README    1;37
        *README.TXT 1;37
        *README.txt 1;37

        # html
        .html   1;35
        .htm    1;35
        .css    1;35
        .less   1;35

        # other
        *.pid         1;30
        *desktop.ini  1;30
        *Desktop.ini  1;30
        *~            1;30
        .ICEauthority 1;30
        .Xauthority   1;30
        .xsession-errors 1;30
        .old          1;30
        .hidden       1;30
        .zcompdump    1;30
      '';
    };
  };
}
