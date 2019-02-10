{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  config = {
    networking.hostName = "myhost";
    
    starlight.server = false;
    starlight.docker = false;
    starlight.desktop = true;
    starlight.proaudio = false;
  };
}
