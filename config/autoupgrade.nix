{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    nix.autoOptimiseStore = true;
    environment.variables = {
      XDG_CACHE_HOME = "/run/cache/$UID";
      XDG_CONFIG_HOME = "/var/config/$UID";
    };
    systemd = {
      tmpfiles.rules = [
        "d /run/cache/ 1771 - users"
        "d /var/config/ 1771 - users 8w"
        "e /var/tmp/ - - - 2w"
      ];
      timers.os-upgrade = {
        description = "StarlightOS Upgrade Timer";
        wantedBy = [ "timers.target" ];
        timerConfig.OnStartupSec = "5min";
      };
      services.os-upgrade = {
        description = "StarlightOS Upgrade Service";
        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;
        serviceConfig = {
          Type = "oneshot";
          LimitNICE = "+1";
        };
        path = with pkgs; [ coreutils gnutar xz.bin gzip gitMinimal config.nix.package.out ];
        environment = config.nix.envVars //
          { inherit (config.environment.sessionVariables) NIX_PATH;
            HOME = "/root";
          } // config.networking.proxy.envVars;
        script = ''
          os upgrade
        '';
      };
    };
  };
}
