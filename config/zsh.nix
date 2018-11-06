{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.zsh.autosuggestions = {
    enable = true;
    strategy = "match_prev_cmd";
    highlightStyle = "fg=0,bold";
  };
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [
      "git"
      "colored-man-pages"
      "zsh-users/zsh-completions"
    ];
  };
  programs.zsh.syntaxHighlighting = {
    enable = true;
    highlighters = [ "main" "brackets" "cursor" "root" "line" ];
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
  programs.zsh.promptInit = ''
    bindkey -v

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
    export ZSH_HIGHLIGHT_STYLES[cursor]='fg=yellow,bold'
    export ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
    export ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
    export ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue,bold'
    export ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
    export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,bold'
    export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=red,bold,underline'
    export ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
    export ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
    export ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
    export ZSH_HIGHLIGHT_STYLES[builtin]='fg=magenta,bold'
    export ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta,bold,underline'
    export ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta,bold'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=blue,bold'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=green,bold'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=cyan,bold'
    export ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=red'
    export ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='fg=yellow,bold'
    export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
    export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan,bold'
  '';
}
