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
  in
    mkMerge [
      (
        mkIf cfg.touchscreen.enable {
          # touchscreen extension enabled!
          users.users.admin.extraGroups = [ "input" ];
          environment = {
            systemPackages = with pkgs; [
              onboard
              xinput_calibrator
            ];
            etc = {
              "onboard/starlight.theme" = {
                text = ''
                  <?xml version="1.0" ?>
                  <theme format="1.3" name="starlight">
                    <color_scheme>Black</color_scheme>
                    <background_gradient>0.0</background_gradient>
                    <key_style>gradient</key_style>
                    <roundrect_radius>16.0</roundrect_radius>
                    <key_size>94.0</key_size>
                    <key_stroke_width>50.0</key_stroke_width>
                    <key_fill_gradient>6.0</key_fill_gradient>
                    <key_stroke_gradient>0.0</key_stroke_gradient>
                    <key_gradient_direction>-23.0</key_gradient_direction>
                    <key_label_font>${cfg.fonts.uiFont} bold</key_label_font>
                    <key_label_overrides>
                      <key group="super" id="LWIN" label="${removeSuffix " " cfg.logo}"/>
                      <key group="super" id="RWIN" label="${removeSuffix " " cfg.logo}"/>
                    </key_label_overrides>
                    <key_shadow_strength>50.0</key_shadow_strength>
                    <key_shadow_size>50.0</key_shadow_size>
                  </theme>
                '';
              };
            };
          };
          services.compton.shadowExclude = [
            "name = 'Onboard'"
          ];
        }
      ) #end mkIf
    ];
}
