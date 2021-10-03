{ config, lib, pkgs, ... }:

{
  imports = [ ./os.nix ];

  starlight = {
    hostname = "myhost";
    # efi = true;
    # localTime = false;
    # logo = " ";
    # desktop = true;
    # docker = false;
  };
}
