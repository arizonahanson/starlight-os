{ config, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
  ];
  environment.systemPackages = with pkgs; [
    polybar sxhkd rofi-unwrapped dunst
    chromium
  ];
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
      mate.mate-system-monitor
      mate.mate-user-guide
      mate.mozo
      mate.pluma
  ];
  fonts.fonts = with pkgs; [
    font-awesome_5
  ];
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.gnome3.seahorse.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  users.users.admin.extraGroups = [ "audio" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      autoLogin = {
        enable = true;
        user = "admin";
        relogin = true;
      };
    };
    desktopManager = {
      mate.enable = true;
      default = "mate";
    };
  };
  services.compton.enable = true;

}

