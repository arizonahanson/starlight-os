{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight.fonts = {
    fontSize = mkOption {
      type = types.int;
      default = 20;
      description = ''
        terminal font size
        (default 18)
      '';
    };
    serifFont = mkOption {
      type = types.str;
      default = "Noto Serif";
      description = ''
        serif font
        (default 'Noto Serif')
      '';
    };
    sansFont = mkOption {
      type = types.str;
      default = "Noto Sans";
      description = ''
        sans font
        (default 'Noto Sans')
      '';
    };
    monoFont = mkOption {
      type = types.str;
      default = "Roboto Mono";
      description = ''
        monospace font
        (default 'Roboto Mono')
      '';
    };
    uiFont = mkOption {
      type = types.str;
      default = "Share Tech";
      description = ''
        ui font
        (default 'Share Tech')
      '';
    };
    terminalFont = mkOption {
      type = types.str;
      default = "Share Tech Mono";
      description = ''
        terminal font
        (default 'Share Tech Mono')
      '';
    };
  };
  config = lib.mkIf config.starlight.desktop {
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        corefonts
        vistafonts
        google-fonts
        font-awesome_5
        stix-two
      ];
      fontconfig = let cfg = config.starlight; in {
        enable = true;
        penultimate.enable = false;
        localConf = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>

            <match target="font">
              <edit name="autohint" mode="assign">
                <bool>false</bool>
              </edit>
            </match>
            <!-- remapppings -->
            <alias binding="same">
              <family>Helvetica</family>
              <accept>
                <family>Arial</family>
              </accept>
            </alias>
            <alias binding="same">
              <family>Times</family>
              <accept>
                <family>Times New Roman</family>
              </accept>
            </alias>
            <alias binding="same">
              <family>Courier</family>
              <accept>
                <family>Courier New</family>
              </accept>
            </alias>
            <alias binding="same">
              <family>Symbol</family>
              <accept>
                <family>STIX Two Math</family>
              </accept>
            </alias>

            <!-- standard families -->
            <alias binding="same">
              <family>sans-serif</family>
              <prefer>
                <family>${cfg.fonts.sansFont}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>serif</family>
              <prefer>
                <family>${cfg.fonts.serifFont}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>monospace</family>
              <prefer>
                <family>${cfg.fonts.monoFont}</family>
              </prefer>
            </alias>

            <!-- fallbacks for missing glyphs -->
            <match target="pattern">
              <edit name="family" mode="prepend">
                <string>Noto Emoji</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="prepend">
                <string>Font Awesome 5 Free Solid</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="prepend">
                <string>DejaVu Sans</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="prepend">
                <string>STIX Two Math</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="prepend">
                <string>${cfg.fonts.uiFont}</string>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
