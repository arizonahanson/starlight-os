{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    (with import <nixpkgs> {}; writeShellScriptBin "tmux-session" ''
      ${tmux}/bin/tmux -2 new-session -A -s "$1"
    '')
  ];
  environment.etc."tmux.conf" = let theme = config.starlight.theme; in {
    text = ''
      set -g default-terminal "screen-256color"
      set -g set-titles on
      set -g set-titles-string "#S #W"
      set -g monitor-activity on
      set -g escape-time 0
      set -g status "on"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-right "#S"
      set -g status-left ""
      set -g renumber-windows on
      setw -g window-status-separator ""
      setw -g window-status-current-format "  #W  "
      setw -g window-status-format "  #W  "
      set -g base-index 1
      setw -g pane-base-index 1

      # default statusbar colors
      set-option -g status-style bg=colour${toString theme.background},fg=colour${toString theme.foreground}
      # default window title colors
      set-window-option -g window-status-style fg=colour${toString theme.background-alt},bg=colour${toString theme.background}
      # active window title colors
      set-window-option -g window-status-current-style fg=colour${toString theme.foreground},bg=colour${toString theme.background-alt}
      # inactive window activity colors
      set-window-option -g window-status-activity-style fg=colour${toString theme.foreground-alt},bg=colour${toString theme.background}
      set-window-option -g window-status-bell-style fg=colour${toString theme.info},bg=colour${toString theme.background}

      # pane border
      set-option -g pane-border-style fg=colour${toString theme.background-alt}
      set-option -g pane-active-border-style fg=colour${toString theme.foreground-alt}

      # message text
      set-option -g message-style bg=colour${toString theme.background},fg=colour${toString theme.foreground}

      # pane number display
      set-option -g display-panes-active-colour colour${toString theme.info}
      set-option -g display-panes-colour colour${toString theme.warning}

      # clock
      set-window-option -g clock-mode-colour colour${toString theme.foreground}
    '';
  };
}
