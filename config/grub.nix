{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    efi = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will boot uefi mode
      '';
    };
  };
  config.boot.loader =
    if config.starlight.efi then {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 10;
    } else {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        version = 2;
      };
      timeout = 10;
    };
}
