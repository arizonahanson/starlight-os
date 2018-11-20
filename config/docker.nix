{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
    storageDriver = "btrfs";
    logDriver = "json-file";
  };
  users.users.admin.extraGroups = [ "docker" ];
}
