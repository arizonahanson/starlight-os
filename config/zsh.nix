{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    setopt appendhistory extendedglob nomatch
    unsetopt autocd beep notify
    bindkey -v
  '';
  programs.zsh.syntaxHighlighting = {
    enable = true;
    highlighters = [ "main" "brackets" "cursor" "root" "line" ];
  };
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

}

