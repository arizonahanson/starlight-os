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
        extraConfig = ''
          [connection]
          connection.mdns=2
          connection.llmnr=2
        '';
      };
      firewall = {
        allowedUDPPorts = [ 5353 5355 ];
        allowedTCPPorts = [ 5355 ];
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
