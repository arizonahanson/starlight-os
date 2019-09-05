{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  starlight = {
    hostname = "myhost";
   # efi = false;
   # localTime = false;
   # logo = " ";
   # desktop = true;
   # docker = false;
   # proaudio = {
   #   enable = false;
   #   device = "none";
   #   capture = "none";
   #   playback = "none";
   #   rate = 44100;
   #   periods = 2;
   #   frames = 1024;
   # };
  };
}
