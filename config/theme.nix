{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages = let
      cfg = config.starlight;
      toRGB = num: removePrefix "#" (elemAt (attrValues cfg.palette) num);
      starlight-icon-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-icon-theme-v1.0";
        src = fetchFromGitHub {
          owner = "isaacwhanson";
          repo = "starlight-icon-theme";
          rev = "v1.0";
          sha256 = "1bqydmzkialx95wf5s9vz3nqgmmajwacbwcrm3c98r1bddfyw3a7";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/icons/starlight/
          cp -r . $out/share/icons/starlight/
        '';
      };
      materia-theme = (pkgs.materia-theme.overrideAttrs (oldAttrs: rec {
        dontBuild = false;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.sassc pkgs.inkscape pkgs.optipng ];
        buildPhase = ''
          patchShebangs .
          sed -i 's/\$HOME\/\./$out\/share\//' ./change_color.sh
          ./change_color.sh -o Starlight <(echo -e "
            MATERIA_STYLE_COMPACT=True\n
            BG=${toRGB cfg.theme.background}\n
            FG=${toRGB cfg.theme.foreground}\n
            MATERIA_VIEW=${toRGB cfg.theme.background}\n
            MATERIA_SURFACE=${toRGB cfg.theme.background-alt}\n
            HDR_BG=${toRGB cfg.theme.background-alt}\n
            HDR_FG=${toRGB cfg.theme.foreground}\n
            SEL_BG=${toRGB cfg.theme.accent}\n
            INACTIVE_FG=${toRGB cfg.theme.foreground-alt}\n")
          echo ".termite {
            padding: ${toString (cfg.fontSize - cfg.borderRadius)}px;
          }" >> $out/share/themes/Starlight/gtk-3.0/gtk.css
        '';
      }));
    in
      with pkgs; [
        bibata-cursors
        gtk-engine-murrine
        (materia-theme)
        (starlight-icon-theme)
      ];
  };
}
