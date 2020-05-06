{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./dconf.nix
  ];
  config = lib.mkIf config.starlight.desktop {
    environment = {
      variables = {
        XDG_CURRENT_DESKTOP = "MATE";
      };
      systemPackages = with pkgs; [
        gnome3.dconf-editor
      ];
      mate.excludePackages = with pkgs.mate; [
        engrampa
        eom
        mate-applets
        mate-backgrounds
        mate-calc
        mate-indicator-applet
        mate-netbook
        mate-screensaver
        mate-sensors-applet
        mate-system-monitor
        mate-user-guide
        mozo
      ];
    };
    # Enable the X11 windowing system.
    services.xserver.desktopManager = {
      mate.enable = true;
    };
  };
}
