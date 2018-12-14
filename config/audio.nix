{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    playerctl sound-theme-freedesktop
  ];

  # Enable sound.
  sound.enable = true;
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    enable = true;
  };
  users.users.admin.extraGroups = [ "audio" ];
}
