{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.starlight;
in
{
  # imports...
  # options...
  options.starlight = {
    server = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will treat as network-reachable server
      '';
    };
  };
  # config...
  config = mkIf cfg.server {
    services = {
      nixosManual.enable = true;
      sshguard = {
        enable = true;
      };
    };
  };
}
