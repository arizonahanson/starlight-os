{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  networking.hostName = "myhost";

  config.starlight.server = false;
  config.starlight.docker = false;
  config.starlight.desktop = true;
}
