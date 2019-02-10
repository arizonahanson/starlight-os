{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight = {
    proaudio = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use jack proaudio setup
      '';
    };
  };
    
  config = {
    environment.systemPackages = with pkgs; [
      playerctl sound-theme-freedesktop
    ];

    # Enable sound.
    sound.enable = true;
    boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
    hardware.pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
    };
    users.users.admin.extraGroups = [ "audio" ];
  };
}
