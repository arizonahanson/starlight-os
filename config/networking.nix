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
    users.users.starlight.extraGroups = [ "networkmanager" ];
    networking = {
      hostName = (config.starlight.hostname);
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      timeServers = [
        "time.nist.gov"
      ];
    };
    services = {
      openssh = {
        enable = true;
      };
      sshguard = {
        enable = true;
        detection_time = 3600;
      };
      resolved = {
        enable = true;
        llmnr = "resolve";
        fallbackDns = [ "8.8.8.8" "2001:4860:4860::8844" ];
      };
    };
  };
}
