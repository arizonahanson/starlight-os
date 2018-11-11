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
      set -g status "on"
      set -g status-left-length "100"
      set -g status-right-length "100"
      set -g status-right "#[fg=colour4]#S  "
      set -g status-left ""
      setw -g window-status-separator ""
      setw -g window-status-current-format " #I #W "
      setw -g window-status-format " #I #W "
      set-option -g status-bg default
      set-option -g status-fg yellow #yellow
      set-option -g status-attr default
      set-window-option -g window-status-fg white
      set-window-option -g window-status-bg default
      set-window-option -g window-status-attr dim
      set-window-option -g window-status-current-fg blue
      set-window-option -g window-status-current-bg default
      set-option -g pane-border-fg white #base2
      set-option -g pane-active-border-fg brightcyan #base1
      set-option -g message-bg white #base2
      set-option -g message-fg brightred #orange
      set-option -g display-panes-active-colour blue #blue
      set-option -g display-panes-colour brightred #orange
      set-window-option -g clock-mode-colour green #green
    '';
  };
}
