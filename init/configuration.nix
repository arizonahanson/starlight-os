{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  starlight = {
    hostname = "myhost";
    # efi = true;
    # localTime = false;
    # desktop = false;
    # docker = false;
    # touchscreen = false;
  };
}
