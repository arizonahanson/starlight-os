{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
    systemd.timers.nixos-upgrade = {
      description = "NixOS Upgrade Timer";
      wantedBy = [ "timers.target" ];
      timerConfig.OnStartupSec = "5min";
    };
    systemd.services.nixos-upgrade = {
      description = "NixOS Upgrade Service";
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig.Type = "oneshot";

      environment = config.nix.envVars //
        { inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        } // config.networking.proxy.envVars;

      path = with pkgs; [ coreutils gnutar xz.bin gzip gitMinimal config.nix.package.out ];

      script = let
        nixos-gc = "${config.nix.package.out}/bin/nix-collect-garbage";
        nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
        in
        ''
          ${nixos-gc} --delete-older-than 2w
          ${nixos-rebuild} switch --upgrade
        '';
    };
    nix.autoOptimiseStore = true;
    systemd.tmpfiles.rules = [
      "d /run/cache/ 1771 - users"
      "d /var/config/ 1771 - users 2w"
      "e /var/tmp/ - - - 2w"
    ];
  };
}
