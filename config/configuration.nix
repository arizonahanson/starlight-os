# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./grub.nix
    ./networking.nix
    ./locale.nix
    ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnumake git
    wget
    vim
    zsh
    polybar sxhkd rofi-unwrapped dunst
    chromium
    pstree
    tree
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
  environment.etc.bspwmrc = {
    text = ''
bspc config border_width         3 
bspc config window_gap           0
bspc config split_ratio          0.50 
bspc config borderless_monocle   true 
bspc config gapless_monocle      true
bspc config single_monocle       true
bspc config focus_follows_pointer false
    '';
  };
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.gnome3.seahorse.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };
    desktopManager.mate.enable = true;
    windowManager.bspwm = {
      enable = true;
      configFile = "/etc/bspwmrc";
    };
  };
  services.compton.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    uid = 1000;
    description = "Administrator";
    extraGroups = [ "wheel" "networkmanager" "audio"];
    shell = "/run/current-system/sw/bin/zsh";
    initialHashedPassword = "$6$ikhOOrtzRA2NJG$YLAZAhI0REoMNMjI9mgE3NGFDnbpTl9yi52QR11p6viuMu.mVEuHmcbU3FFhTvSP4Pro.dvYfSpmKz/1Ngk.P/";
  };
  users.mutableUsers = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
