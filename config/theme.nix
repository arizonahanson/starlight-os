{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages =
      let
        cfg = config.starlight;
        toRGB = num: removePrefix "#" (elemAt (attrValues cfg.palette) num);
        toPx = pt: pt * 4 / 3;
        starlight-oomox-theme = with pkgs; stdenv.mkDerivation rec {
          name = "starlight-oomox-theme-v1.0";
          src = fetchFromGitHub {
            owner = "themix-project";
            repo = "oomox";
            rev = "1.13.3";
            sha256 = "0krhvd73gm8znfr088l9d5195y6c7bsabdpf7fjdivjcrjv1a9qz";
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
            pushd plugins/theme_oomox
            patchShebangs .
            echo "
            BG=${toRGB cfg.theme.bg}
            FG=${toRGB cfg.theme.fg}
            HDR_BG=${toRGB cfg.theme.bg}
            HDR_FG=${toRGB cfg.theme.fg}
            SEL_BG=${toRGB cfg.theme.accent}
            SEL_FG=${toRGB cfg.theme.bg}
            TXT_BG=${toRGB cfg.theme.bg-alt}
            TXT_FG=${toRGB cfg.theme.fg}
            BTN_BG=${toRGB cfg.theme.bg-alt}
            BTN_FG=${toRGB cfg.theme.fg}
            HDR_BTN_BG=${toRGB cfg.theme.bg-alt}
            HDR_BTN_FG=${toRGB cfg.theme.fg}
            WM_BORDER_WIDTH=0
            ROUNDNESS=8
            SPACING=8
            GRADIENT=0.6
            GTK3_GENERATE_DARK=True
            CARET1_FG=${removePrefix "#" cfg.palette.cursor}
            CARET2_FG=${toRGB cfg.theme.bg-alt}
            CARET_SIZE=0.08
            OUTLINE_WIDTH=${toString cfg.borderWidth}
            BTN_OUTLINE_WIDTH=${toString cfg.borderWidth}
            BTN_OUTLINE_OFFSET=-${toString cfg.borderWidth}
            " > /build/source/starlight.colors
            HOME=/build/source ./change_color.sh -o Starlight -m all -t $out/share/themes /build/source/starlight.colors
            echo ".termite {
              padding: ${toString ((toPx cfg.fonts.fontSize) / 2)}px;
            }" >> $out/share/themes/Starlight/gtk-3.20/gtk.css
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
