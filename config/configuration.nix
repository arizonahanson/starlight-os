{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./grub.nix
    ./networking.nix
    ./locale.nix
    ./base.nix
    ./desktop.nix
    #./server.nix
    #./docker.nix
    ./wine.nix
    ];
}
