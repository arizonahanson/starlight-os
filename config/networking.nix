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
        blocktime = 3600; # hour initial block
        detection_time = 28800; # 8 hour memory
        blacklist_threshold = 100; # 10 strikes
      };
      resolved = {
        enable = true;
        llmnr = "resolve";
        fallbackDns = [ "8.8.8.8" "2001:4860:4860::8844" ];
      };
    };
  };
}
