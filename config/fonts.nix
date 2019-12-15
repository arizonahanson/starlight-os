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

            <!-- overrides -->
            <match target="pattern">
              <test qual="any" name="family">
                <string>-apple-system</string>
              </test>
              <edit name="family" mode="assign" binding="strong">
                <string>Share Tech</string>
              </edit>
            </match>
            <match target="pattern">
              <test qual="any" name="family">
                <string>BlinkMacSystemFont</string>
              </test>
              <edit name="family" mode="assign" binding="strong">
                <string>Share Tech</string>
              </edit>
            </match>
            <match target="pattern">
              <test qual="any" name="family">
                <string>Segoe UI</string>
              </test>
              <edit name="family" mode="assign" binding="strong">
                <string>Share Tech</string>
              </edit>
            </match>
            <match target="pattern">
              <test qual="any" name="family">
                <string>SFMono-Regular</string>
              </test>
              <edit name="family" mode="assign" binding="strong">
                <string>monospace</string>
              </edit>
            </match>
            <match target="pattern">
              <test qual="any" name="family">
                <string>Menlo</string>
              </test>
              <edit name="family" mode="assign" binding="strong">
                <string>monospace</string>
              </edit>
            </match>

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
