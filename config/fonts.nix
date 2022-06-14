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
    uiFont = mkOption {
      type = types.str;
      default = "DejaVu Sans";
      description = ''
        ui font
        (default 'DejaVu Sans')
      '';
    };
    terminalFont = mkOption {
      type = types.str;
      default = "JetBrains Mono";
      description = ''
        terminal font
        (default 'JetBrains Mono')
      '';
    };
  };
  config = lib.mkIf config.starlight.desktop {
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        corefonts
        meslo-lg
        font-awesome_5
        lmodern
        lmmath
        stix-two
        jetbrains-mono
      ];
      fontconfig = let cfg = config.starlight; in
        {
          enable = true;
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
                <family>Monaco</family>
                <accept>
                  <family>Meslo LG M</family>
                </accept>
              </alias>
              <alias binding="same">
                <family>Menlo</family>
                <accept>
                  <family>Meslo LG M</family>
                </accept>
              </alias>
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

              <!-- families -->
              <alias binding="same">
                <family>SFMono-Regular</family>
                <default>
                  <family>monospace</family>
                </default>
              </alias>
              <alias>
                <family>JetBrains Mono</family>
                <default>
                  <family>monospace</family>
                </default>
              </alias>

              <!-- remove multiple family (first match) -->
              <match>
                <test compare="eq" name="family">
                  <string>sans-serif</string>
                </test>
                <test compare="eq" name="family">
                  <string>monospace</string>
                </test>
                <edit mode="delete" name="family"/>
              </match>

              <!-- fallbacks -->
              <alias binding="same">
                <family>sans-serif</family>
                <prefer>
                  <family>STIX Two Math</family>
                  <family>Latin Modern Math</family>
                  <family>Font Awesome 5 Free Solid</family>
                  <family>Latin Modern Sans</family>
                  <family>DejaVu Sans</family>
                </prefer>
              </alias>
              <alias binding="same">
                <family>serif</family>
                <prefer>
                  <family>STIX Two Math</family>
                  <family>Latin Modern Math</family>
                  <family>Font Awesome 5 Free Solid</family>
                  <family>Latin Modern Roman</family>
                  <family>DejaVu Serif</family>
                </prefer>
              </alias>
              <alias binding="same">
                <family>monospace</family>
                <prefer>
                  <family>STIX Two Math</family>
                  <family>Latin Modern Math</family>
                  <family>Font Awesome 5 Free Solid</family>
                  <family>Latin Modern Mono</family>
                  <family>DejaVu Sans Mono</family>
                </prefer>
              </alias>

            </fontconfig>
          '';
        };
    };
  };
}
