{ config, pkgs, ... }:

{
  environment.mate.excludePackages = with pkgs; [
      mate.caja
      mate.libmateweather
      mate.marco
      mate.mate-notification-daemon
      mate.mate-panel
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
      #mate.mate-system-monitor
      mate.mate-user-guide
      mate.mozo
      mate.pluma
  ];
  # dconf
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Enable the X11 windowing system.
  services.xserver.desktopManager = {
    mate.enable = true;
    default = "mate";
  };
}


