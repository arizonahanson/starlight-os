{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    hostname = mkOption {
      type = types.str;
      description = ''
        hostname
      '';
    };
  };
  config = {
    users.users.admin.extraGroups = [ "networkmanager" ];
    networking = {
      hostName = (config.starlight.hostname);
      networkmanager = {
        enable = true;
        dns = "dnsmasq";
      };
      timeServers = [
        "time1.google.com"
        "time2.google.com"
        "time3.google.com"
        "time4.google.com"
      ];
    };
    services = {
      openssh.enable = true;
    };
  };
}
