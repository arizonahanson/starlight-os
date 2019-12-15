{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight.fonts = {
    fontSize = mkOption {
      type = types.int;
      default = 18;
      description = ''
        terminal font size
        (default 18)
      '';
    };
    serifFont = mkOption {
      type = types.str;
      default = "Roboto Slab";
      description = ''
        serif font
        (default 'Roboto Slab')
      '';
    };
    sansFont = mkOption {
      type = types.str;
      default = "Roboto";
      description = ''
        sans font
        (default 'Roboto')
      '';
    };
    monoFont = mkOption {
      type = types.str;
      default = "Share Tech Mono";
      description = ''
        monospace font
        (default 'Share Tech Mono')
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
      fonts = with pkgs; [
        corefonts
        vistafonts
        google-fonts
        font-awesome_5
        noto-fonts-emoji
        stix-two
      ];
      fontconfig = let cfg = config.starlight; in {
        enable = true;
        penultimate.enable = true;
        localConf = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>

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
              <family>-apple-system</family>
              <prefer>
                <family>${cfg.fonts.uiFont}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>BlinkMacSystemFont</family>
              <prefer>
                <family>${cfg.fonts.uiFont}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>Segoe UI</family>
              <prefer>
                <family>${cfg.fonts.uiFont}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>SFMono-Regular</family>
              <prefer>
                <family>monospace</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>Menlo</family>
              <prefer>
                <family>monospace</family>
              </prefer>
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
              <edit name="family" mode="append">
                <string>${cfg.fonts.uiFont}</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="append">
                <string>STIX Two Math</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="append">
                <string>DejaVu Sans</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="append">
                <string>Font Awesome 5 Free Solid</string>
              </edit>
            </match>
            <match target="pattern">
              <edit name="family" mode="append">
                <string>Noto Emoji</string>
              </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
