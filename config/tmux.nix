{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    (with import <nixpkgs> {}; writeShellScriptBin "tmux-session" ''
      ${tmux}/bin/tmux -2 new-session -A -s "$1"
    '')
  ];
  environment.etc."tmux.conf" = {
    text = ''
      set -g default-terminal "screen-256color"
      set -g set-titles on
      set -g set-titles-string "#W"
      set -g monitor-activity on
      set -g escape-time 0
      set -g status "on"
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
      set-option -g status-style bg=default,fg=yellow

      # default window title colors
      set-window-option -g window-status-style fg=brightblack,bg=default

      # active window title colors
      set-window-option -g window-status-current-style fg=brightwhite,bg=brightblack

      # inactive window activity colors
      set-window-option -g window-status-activity-style fg=white,bg=default
      set-window-option -g window-status-bell-style fg=red,bg=default

      # pane border
      set-option -g pane-border-style fg=brightblack
      set-option -g pane-active-border-style fg=white

      # message text
      set-option -g message-style bg=black,fg=brightwhite

      # pane number display
      set-option -g display-panes-active-colour blue
      set-option -g display-panes-colour brightred

      # clock
      set-window-option -g clock-mode-colour brightwhite
    '';
  };
}
