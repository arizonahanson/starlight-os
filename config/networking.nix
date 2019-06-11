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
    system.nssHosts = [ "mdns" ];
    services = {
      openssh.enable = true;
      avahi = {
        enable = true;
        nssmdns = true;
        ipv6 = false;
      };
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
    environment.systemPackages = with pkgs; [ nssmdns ];
    environment.etc = let
      net = config.networking;
      resolv = config.services.resolved; in {
      "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
      "systemd/resolved.conf".text = ''
        [Resolve]
        ${optionalString (net.nameservers != [])
          "DNS=${concatStringsSep " " net.nameservers}"}
        ${optionalString (resolv.fallbackDns != [])
          "FallbackDNS=${concatStringsSep " " resolv.fallbackDns}"}
        ${optionalString (resolv.domains != [])
          "Domains=${concatStringsSep " " resolv.domains}"}
        LLMNR=${resolv.llmnr}
        DNSSEC=${resolv.dnssec}
        ${resolv.extraConfig}
      '';
    };
  };
}
