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
            ROUNDNESS=4
            BG=${toRGB cfg.theme.background}
            FG=${toRGB cfg.theme.foreground}
            HDR_BG=${toRGB cfg.theme.background}
            HDR_FG=${toRGB cfg.theme.foreground}
            SEL_BG=${toRGB cfg.theme.accent}
            INACTIVE_FG=${toRGB cfg.theme.foreground-alt}
            MATERIA_VIEW=${toRGB cfg.theme.background}
            MATERIA_SURFACE=${toRGB cfg.theme.background}")
          echo "/* terminal padding */
          .termite {
            padding: ${toString ((cfg.fontSize * 2) / 3)}px;
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
