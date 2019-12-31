{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages = let
      cfg = config.starlight;
      toRGB = num: removePrefix "#" (elemAt (attrValues cfg.palette) num);
      toPx = pt: pt * 4 / 3;
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
            ROUNDNESS=8
            SPACING=8
            BG=${toRGB cfg.theme.bg}
            FG=${toRGB cfg.theme.fg}
            HDR_BG=${toRGB cfg.theme.bg}
            HDR_FG=${toRGB cfg.theme.fg}
            SEL_BG=${toRGB cfg.theme.accent}
            INACTIVE_FG=${toRGB cfg.theme.fg-alt}
            MATERIA_VIEW=${toRGB cfg.theme.bg}
            MATERIA_SURFACE=${toRGB cfg.theme.bg}")
          echo "/* terminal padding */
          .termite {
            padding: ${toString ((toPx cfg.fonts.fontSize) / 2)}px;
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
