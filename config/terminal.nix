{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment =
      let
        term = (
          pkgs.termite.override {
            configFile = "/etc/termite.conf";
          }
        );
      in
      {
        systemPackages = with pkgs; [
          (term)
          (
            with import <nixpkgs> { }; writeShellScriptBin "terminal" ''
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
                ${term}/bin/termite --class="$CLASS_NAME"
              fi
            ''
          )
        ];
        variables = {
          TERMINAL = "${term}/bin/termite";
        };
        etc."termite.conf" =
          let
            cfg = config.starlight;
            palette = config.starlight.palette;
            theme = config.starlight.theme;
            toRGB = num: elemAt (attrValues palette) num;
          in
          {
            text = ''
              [options]
              font = ${cfg.fonts.terminalFont} ${toString cfg.fonts.fontSize}
              allow_bold = false
              mouse_autohide = true
              [colors]
              foreground      = ${toRGB theme.fg}
              foreground_bold = ${toRGB theme.fg}
              background      = ${toRGB theme.bg}
              cursor          = ${palette.cursor}
              color0  = ${palette.color00}
              color1  = ${palette.color01}
              color2  = ${palette.color02}
              color3  = ${palette.color03}
              color4  = ${palette.color04}
              color5  = ${palette.color05}
              color6  = ${palette.color06}
              color7  = ${palette.color07}
              color8  = ${palette.color08}
              color9  = ${palette.color09}
              color10 = ${palette.color10}
              color11 = ${palette.color11}
              color12 = ${palette.color12}
              color13 = ${palette.color13}
              color14 = ${palette.color14}
              color15 = ${palette.color15}
            '';
          };
      };
  };
}
