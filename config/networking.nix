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
      firewall = {
        allowedTCPPorts = [ 5355 ];
        allowedUDPPorts = [ 5355 ];
      };
      networkmanager = {
        enable = true;
        extraConfig = ''
          [connection]
          connection.llmnr=2
        '';
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
      resolved = {
        enable = true;
      };
    };
  };
}
