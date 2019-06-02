{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./dconf.nix
  ];
  config = lib.mkIf config.starlight.desktop {
    environment.variables = {
      XDG_CURRENT_DESKTOP = "MATE";
    };
    environment.systemPackages = with pkgs; [
      gnome3.dconf-editor
    ];
    environment.mate.excludePackages = with pkgs; [
        mate.engrampa
        mate.eom
        mate.mate-applets
        mate.mate-backgrounds
        mate.mate-calc
        mate.mate-indicator-applet
        mate.mate-netbook
        mate.mate-screensaver
        mate.mate-sensors-applet
        mate.mate-system-monitor
        mate.mate-user-guide
        mate.mozo
        mate.pluma
    ];

    # Enable the X11 windowing system.
    services.xserver.desktopManager = {
      mate.enable = true;
      default = "mate";
    };
  };
}


