{ config, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./mate.nix
  ];
  environment.systemPackages = with pkgs; [
    polybar sxhkd rofi-unwrapped dunst
    chromium
  ];
  fonts.fonts = with pkgs; [
    font-awesome_5
  ];
  # keyring
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
  };
  services.compton.enable = true;

}

