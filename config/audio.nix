{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    playerctl jack2
    sound-theme-freedesktop
  ];

  # Enable sound.
  sound.enable = true;
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  hardware.pulseaudio = {
    package = (pkgs.pulseaudio.override {
      jackaudioSupport = true;
      x11Support = true;
    });
    enable = true;
  };
  users.users.admin.extraGroups = [ "networkmanager" ];
}
