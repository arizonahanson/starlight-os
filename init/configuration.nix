{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  config.starlight.server = false;
  config.starlight.docker = false;
}
