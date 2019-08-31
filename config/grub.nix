{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    efi = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will boot ufi mode
      '';
    };
  };
  config.boot.loader = if config.starlight.efi then {
    timeout = 10;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  } else {
    timeout = 10;
    grub = {
      enable = true;
      device = "/dev/sda";
      version = 2;
      useOSProber = true;
    };
  };
}

