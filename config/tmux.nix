{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    (
      with import <nixpkgs> {}; writeShellScriptBin "tmux-session" ''
        ${tmux}/bin/tmux -2 new-session -A -s "$1"
      ''
    )
  ];
  environment.etc."tmux.conf" = let
    theme = config.starlight.theme;
  in
    {
      text = ''
        set -g default-terminal "screen-256color"
        set -g set-titles on
        set -g set-titles-string "#W"
        set -g monitor-activity on
        set -g escape-time 0
        set -g status "on"
        set -g status-keys "vi"
        set -g status-left-length "100"
        set -g status-right-length "100"
        set -g status-right ""
        set -g status-left ""
        set -g renumber-windows on
        setw -g window-status-separator ""
        setw -g window-status-current-format " #W "
        setw -g window-status-format " #W "
        set -g base-index 1
        setw -g pane-base-index 1

        # default statusbar colors
        set-option -g status-style bg=colour${toString theme.bg},fg=colour${toString theme.fg}
        # default window title colors
        set-window-option -g window-status-style fg=colour${toString theme.bg-alt},bg=colour${toString theme.bg}
        # active window title colors
        set-window-option -g window-status-current-style fg=colour${toString theme.fg},bg=colour${toString theme.bg}
        # inactive window activity colors
        set-window-option -g window-status-activity-style fg=colour${toString theme.fg-alt},bg=colour${toString theme.bg}
        set-window-option -g window-status-bell-style fg=colour${toString theme.info},bg=colour${toString theme.bg}

        # pane border
        set-option -g pane-border-style fg=colour${toString theme.bg-alt}
        set-option -g pane-active-border-style fg=colour${toString theme.fg-alt}

        # message text
        set-option -g message-style bg=colour${toString theme.bg},fg=colour${toString theme.fg}

        # pane number display
        set-option -g display-panes-active-colour colour${toString theme.fg}
        set-option -g display-panes-colour colour${toString theme.fg-alt}

        # clock
        set-window-option -g clock-mode-colour colour${toString theme.fg}
      '';
    };
}
