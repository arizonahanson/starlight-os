{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages = let
      cfg = config.starlight;
      toRGB = num: removePrefix "#" (elemAt (attrValues cfg.palette) num);
      toPx = pt: pt * 4 / 3;
      starlight-oomox-theme = with pkgs; stdenv.mkDerivation rec {
        name = "starlight-oomox-theme-v1.0";
        src = fetchFromGitHub {
          owner = "themix-project";
          repo = "oomox";
          rev = "1.12.5.3";
          sha256 = "0xz2j6x8zf44bjsq2h1b5105h35z8mbrh8b97i5z5j0zb8k5zhj2";
          fetchSubmodules = true;
        };
        dontBuild = true;
        nativeBuildInputs = [ glib libxml2 bc ];
        buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
        propagatedUserEnvPkgs = [ gtk-engine-murrine ];
        installPhase = ''
          # icon theme
          mkdir -p $out/share/icons/Starlight
          pushd plugins/icons_suruplus_aspromauros
          patchShebangs .
          export SURUPLUS_GRADIENT_ENABLED=True
          export SURUPLUS_GRADIENT1=${toRGB cfg.theme.fg}
          export SURUPLUS_GRADIENT2=${toRGB cfg.theme.accent}
          ./change_color.sh -o Starlight -d $out/share/icons/Starlight -c ${toRGB cfg.theme.fg}
          popd
          # gtk theme
          mkdir -p $out/share/themes/Starlight
          pushd plugins/theme_materia/materia-theme
          patchShebangs .
          sed -i 's/\$HOME\/\./$out\/share\//' ./change_color.sh
          HOME=/build/source ./change_color.sh -o Starlight <(echo -e "
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
          popd
        '';
      };
    in
      with pkgs; [
        bibata-cursors
        gtk-engine-murrine
        (starlight-oomox-theme)
      ];
  };
}
