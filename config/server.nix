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
    environment.systemPackages = with pkgs; [
      w3m
      iftop
    ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services = {
      sshguard = {
        enable = true;
        detection_time = 3600;
      };
    };
  };
}
