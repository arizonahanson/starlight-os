{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
    storageDriver = "btrfs";
    logDriver = "syslog";
  };
  users.users.admin.extraGroups = [ "docker" ];
}
