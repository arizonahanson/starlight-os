{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    version = 2;
    useOSProber = true;
  };
}

