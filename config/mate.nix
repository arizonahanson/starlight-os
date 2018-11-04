{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
  ];
  environment.mate.excludePackages = with pkgs; [
      mate.atril
      mate.caja-extensions
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
      mate.mate-utils
      mate.mozo
      mate.pluma
  ];

  # Enable the X11 windowing system.
  services.xserver.desktopManager = {
    mate.enable = true;
    default = "mate";
  };
}


