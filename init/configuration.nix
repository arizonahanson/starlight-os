{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  starlight = {
    hostname = "myhost";
   # logo = "• ";
   # desktop = true;
   # docker = false;
   # server = false;
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
