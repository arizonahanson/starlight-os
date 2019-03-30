{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  networking.hostName = "myhost";
    
  starlight.desktop = true;
  #starlight.docker = false;
  #starlight.server = false;
  starlight.proaudio = {
    enable = false;
    device = "none";
    capture = "hw:0";
    playback = "hw:0";
    rate = 44100;
    periods = 3;
    frames = 1024;
  };
}
