{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  config = {
    networking.hostName = "myhost";
    
    starlight.desktop = true;
    starlight.docker = false;
    starlight.proaudio = false;
    starlight.server = false;
  };
}
