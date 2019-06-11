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
        #dns = "systemd-resolved";
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
        fallbackDns = [ "8.8.8.8" ];
      };
    };
    #environment.etc."NetworkManager/conf.d/extra.conf" = {
    #  text = ''
    #    [connection]
    #    connection.mdns=1
    #  '';
    #};
    #environment.systemPackages = with pkgs; [ nssmdns ];
    #systemd = {
    #  additionalUpstreamSystemUnits = [
    #    "systemd-resolved.service"
    #  ];
    #  services.systemd-resolved = {
    #    wantedBy = [ "multi-user.target" ];
    #    restartTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
    #  };
    #};
    #environment.etc = let
    #  net = config.networking;
    #  resolv = config.services.resolved; in {
    #  "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
    #  "systemd/resolved.conf".text = ''
    #    [Resolve]
    #    ${optionalString (net.nameservers != [])
    #      "DNS=${concatStringsSep " " net.nameservers}"}
    #    ${optionalString (resolv.fallbackDns != [])
    #      "FallbackDNS=${concatStringsSep " " resolv.fallbackDns}"}
    #    ${optionalString (resolv.domains != [])
    #      "Domains=${concatStringsSep " " resolv.domains}"}
    #    LLMNR=${resolv.llmnr}
    #    DNSSEC=${resolv.dnssec}
    #    ${resolv.extraConfig}
    #  '';
    #};
  };
}
