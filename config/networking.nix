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
        dns = "systemd-resolved";
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
        fallbackDns = [ "8.8.8.8" ];
      };
    };
    systemd = {
      additionalUpstreamSystemUnits = [
        "systemd-resolved.service"
      ];
      services.systemd-resolved = {
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
      };
    };
    environment.etc = {
      "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
      "systemd/resolved.conf".text = ''
        [Resolve]
        ${optionalString (config.networking.nameservers != [])
          "DNS=${concatStringsSep " " config.networking.nameservers}"}
        ${optionalString (config.services.resolved.fallbackDns != [])
          "FallbackDNS=${concatStringsSep " " config.services.resolved.fallbackDns}"}
        ${optionalString (config.services.resolved.domains != [])
          "Domains=${concatStringsSep " " config.services.resolved.domains}"}
        LLMNR=${config.services.resolved.llmnr}
        DNSSEC=${config.services.resolved.dnssec}
        ${config.services.resolved.extraConfig}
      '';
    };
  };
}
