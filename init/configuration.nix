{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  networking.hostName = "myhost";
  #starlight = {
  # desktop = true;
  # docker = false;
  # server = false;
  # proaudio = {
  #   enable = false;
  #   enable = false;
  #   device = "none";
  #   capture = "hw:0";
  #   playback = "hw:0";
  #   rate = 44100;
  #   periods = 3;
  #   frames = 1024;
  # };
  # palette = {
  #   background = "#212121";
  #   foreground = "#c7c7c7";
  #   color0 = "#212121";
  # };
  #};
}
