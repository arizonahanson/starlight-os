{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    (with import <nixpkgs> {}; writeShellScriptBin "tmux-session" ''
      ${tmux}/bin/tmux -2 new-session -A -s "$1"
    '')
  ];
  environment.etc."tmux.conf" = {
    mode = "0644";
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
      set-option -g status-bg default
      set-option -g status-fg yellow
      set-option -g status-attr default

      # default window title colors
      set-window-option -g window-status-fg brightblack
      set-window-option -g window-status-bg default
      #set-window-option -g window-status-attr dim

      # active window title colors
      set-window-option -g window-status-current-fg brightwhite
      set-window-option -g window-status-current-bg brightblack
      #set-window-option -g window-status-current-attr bright

      # inactive window activity colors
      setw -g window-status-activity-attr none
      set-window-option -g window-status-activity-fg white
      set-window-option -g window-status-activity-bg default
      setw -g window-status-bell-attr none
      set-window-option -g window-status-bell-fg red
      set-window-option -g window-status-bell-bg default

      # pane border
      set-option -g pane-border-fg brightblack
      set-option -g pane-active-border-fg brightwhite

      # message text
      set-option -g message-bg black
      set-option -g message-fg brightwhite

      # pane number display
      set-option -g display-panes-active-colour blue
      set-option -g display-panes-colour brightred

      # clock
      set-window-option -g clock-mode-colour green
    '';
  };
}
