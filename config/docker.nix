{ config, lib, pkgs, ... }:

with lib;

let cfg = config.starlight; in {
  # imports...
  # options...
  options.starlight = {
    docker = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use docker
      '';
    };
  };
  # config...
  config = mkIf cfg.docker {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      storageDriver = "btrfs";
      logDriver = "json-file";
    };
    users.users.admin.extraGroups = [ "docker" ];
  };
}
