{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight.touchscreen = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use touchscreen setup
      '';
    };
  };
    
  config = let
    cfg = config.starlight;
    toRGB = num: elemAt (attrValues cfg.palette) num;
  in mkMerge [
    (mkIf cfg.touchscreen.enable {
      # touchscreen extension enabled!
      users.users.admin.extraGroups = [ "input" ];
      nixpkgs.config.packageOverrides = pkgs: {
        onboard = pkgs.onboard.overrideAttrs (oldAttrs: rec {
          strictDeps = false;
          preInstall = ''
            mkdir -p $out/etc/xdg/autostart
            cp build/share/autostart/onboard-autostart.desktop $out/etc/xdg/autostart/
          '';
        });
      };
      environment = {
        systemPackages = with pkgs; [
            onboard xinput_calibrator
        ];
        etc = {
          "onboard/starlight.theme" = {
            text = ''
              <?xml version="1.0" ?>
              <theme format="1.3" name="starlight">
                <color_scheme>starlight</color_scheme>
                <background_gradient>0.0</background_gradient>
                <key_style>gradient</key_style>
                <roundrect_radius>16.0</roundrect_radius>
                <key_size>94.0</key_size>
                <key_stroke_width>50.0</key_stroke_width>
                <key_fill_gradient>6.0</key_fill_gradient>
                <key_stroke_gradient>0.0</key_stroke_gradient>
                <key_gradient_direction>-23.0</key_gradient_direction>
                <key_label_font>Share Tech bold</key_label_font>
                <key_label_overrides>
                  <key group="super" id="LWIN" label="${removeSuffix " " cfg.logo}"/>
                  <key group="super" id="RWIN" label="${removeSuffix " " cfg.logo}"/>
                </key_label_overrides>
                <key_shadow_strength>50.0</key_shadow_strength>
                <key_shadow_size>50.0</key_shadow_size>
              </theme>
            '';
          };
          "onboard/starlight.colors" = {
            text = ''
              <?xml version="1.0"?>
              <color_scheme name="starlight" format="2.1">
              <window type="key-popup">
                <color element="fill" rgb="${toRGB cfg.theme.foreground-alt}" opacity="0.9"/>
              </window>
              <layer> <color element="background" rgb="#000000" opacity="1.0"/> </layer>
              <layer> <color element="background" rgb="${toRGB cfg.theme.background}" opacity="0.9"/> </layer>
              <layer> <color element="background" rgb="${toRGB cfg.theme.background}" opacity="0.9"/> </layer>
              <key_group>
                <color element="fill"   rgb="${toRGB cfg.theme.background}"/>
                <color element="stroke" rgb="${toRGB cfg.theme.background-alt}"/>
                <color element="label"  rgb="${toRGB cfg.theme.foreground}"/>
                <color element="fill" locked="true" rgb="${toRGB cfg.theme.background-alt}"/>
                icon0
                <key_group>
                  <color element="fill" locked="true" rgb="${toRGB cfg.theme.background-alt}"/>
                  <color element="fill" rgb="${toRGB cfg.theme.foreground}"/>
                  icon1, icon2
                </key_group>
                <!-- dark keys -->
                <key_group>
                  <color element="fill" rgb="${toRGB cfg.theme.background}"/>
                  <color element="stroke" rgb="${toRGB cfg.theme.background-alt}"/>
                  <color element="label" rgb="${toRGB cfg.theme.foreground}"/>
                  <color element="fill" locked="true" rgb="${toRGB cfg.theme.background-alt}"/>
                  icon3,
                  RCTL, LCTL, RALT, LALT, LWIN, CAPS,
                  LFSH, RTSH, NMLK,
                  MENU, RWIN, BKSP, TAB, RTRN,
                  KPDL, KPEN, KPSU, KPDV, KPAD, KPMU,
                  LEFT, RGHT, UP, DOWN, INS, DELE, HOME, END, PGUP, PGDN,
                  F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12,
                  Prnt, Pause, ESC, Scroll,
                  secondaryclick, middleclick, doubleclick, dragclick, hoverclick,
                  hide, showclick, move, layer,
                  quit, inputline,
                  <!-- word suggestions -->
                  <key_group>
                    <color element="fill" rgb="${toRGB cfg.theme.background}"/>
                    prediction
                    <key_group>
                      <color element="fill" rgb="${toRGB cfg.theme.background}" opacity="0.8"/>
                      wordlist, pause-learning.wordlist, language.wordlist, hide.wordlist
                    </key_group>
                  </key_group>
                </key_group>
                <!-- snippets -->
                <key_group>
                  <color element="fill" rgb="${toRGB cfg.theme.background}"/>
                  <color element="stroke" rgb="${toRGB cfg.theme.background-alt}"/>
                  <color element="fill" locked="true" rgb="${toRGB cfg.theme.background-alt}"/>
                  m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15
                </key_group>
                <!-- red preferences -->
                <key_group>
                  <color element="fill" rgb="${toRGB cfg.theme.background}"/>
                  <color element="stroke" rgb="${toRGB cfg.theme.background-alt}"/>
                  <color element="fill" locked="true" rgb="${toRGB cfg.theme.background-alt}"/>
                  settings
                </key_group>
              </key_group>
              </color_scheme>
            '';
          };
        };
      };
      services.compton.shadowExclude = [
        "name = 'Onboard'"
      ];
    }) #end mkIf
  ];
}
