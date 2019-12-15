{ config, lib, pkgs, ... }:

with lib;

{
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
      fontconfig = {
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
                <family>Share Tech</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>BlinkMacSystemFont</family>
              <prefer>
                <family>Share Tech</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>Segoe UI</family>
              <prefer>
                <family>Share Tech</family>
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
                <family>DejaVu Sans</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>serif</family>
              <prefer>
                <family>DejaVu Serif</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>monospace</family>
              <prefer>
                <family>Share Tech Mono</family>
              </prefer>
            </alias>

            <!-- fallbacks for missing glyphs -->
            <match target="pattern">
              <edit name="family" mode="append">
                <string>Share Tech</string>
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
