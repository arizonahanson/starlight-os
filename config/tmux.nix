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
set -g status-right "#[fg=colour7]#S  "
set -g status-left ""
setw -g window-status-separator ""
setw -g window-status-current-format " #I #W "
setw -g window-status-format " #I #W "

#### COLOUR (Solarized dark)

# default statusbar colors
#set-option -g status-bg black #base02
set-option -g status-bg default
set-option -g status-fg yellow #yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg brightblack #base0
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim

# active window title colors
#set-window-option -g window-status-current-fg brightred #orange
set-window-option -g window-status-current-fg white
set-window-option -g window-status-current-bg default
#set-window-option -g window-status-current-attr bright

# pane border
set-option -g pane-border-fg black #base02
set-option -g pane-active-border-fg brightgreen #base01

# message text
set-option -g message-bg black #base02
set-option -g message-fg brightred #orange

# pane number display
set-option -g display-panes-active-colour blue #blue
set-option -g display-panes-colour brightred #orange

# clock
set-window-option -g clock-mode-colour green #green
    '';
  };
}
