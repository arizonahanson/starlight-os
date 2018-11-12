{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune.enable = true;
    storageDriver = "btrfs";
  };
  users.users.admin.extraGroups = [ "docker" ];
}
