{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment = let term = (pkgs.termite.override {
        configFile = "/etc/termite.conf";
    }); in {
      systemPackages = with pkgs; [
        (term)
        (with import <nixpkgs> {}; writeShellScriptBin "terminal" ''
          CLASS_NAME="terminal"
          # does term with CLASS_NAME exist?
          if xdo id -N "$CLASS_NAME">/dev/null; then
            # focus, move to current desktop the existing term with CLASS_NAME
            for NODE_ID in $(xdo id -N $CLASS_NAME); do
              bspc node $NODE_ID -d focused -m focused
              bspc node -f $NODE_ID
            done
          else
            # create new term with CLASS_NAME
            # create new tmux session, or attach if exists
            ${term}/bin/termite -e "tmux-session '${config.starlight.logo}'" --class="$CLASS_NAME"
          fi
        '')
      ];
      variables = {
        TERMINAL = "${term}/bin/termite";
      };
      etc."termite.conf" = let palette = config.starlight.palette; in {
        text = ''
          [options]
          font = Share Tech Mono 16
          allow_bold = false
    
          [colors]
    
          # special
          foreground      = ${palette.foreground}
          foreground_bold = ${palette.foreground}
          cursor          = ${palette.cursor}
          background      = ${palette.background}
    
          # black
          color0  = ${palette.color0}
          color8  = ${palette.color8}
    
          # red
          color1  = ${palette.color1}
          color9  = ${palette.color9}
    
          # green
          color2  = ${palette.color2}
          color10 = ${palette.color10}
    
          # yellow
          color3  = ${palette.color3}
          color11 = ${palette.color11}
    
          # blue
          color4  = ${palette.color4}
          color12 = ${palette.color12}
    
          # magenta
          color5  = ${palette.color5}
          color13 = ${palette.color13}
    
          # cyan
          color6  = ${palette.color6}
          color14 = ${palette.color14}
    
          # white
          color7  = ${palette.color7}
          color15 = ${palette.color15}
        '';
      };
    };
  };
}
