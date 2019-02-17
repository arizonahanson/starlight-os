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
    
  config = mkMerge [
    {
      # Enable sound.
      sound.enable = true;
      boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
      users.users.admin.extraGroups = [ "audio" ];
      hardware.pulseaudio = {
        support32Bit = true;
        package = pkgs.pulseaudioFull;
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        playerctl sound-theme-freedesktop
      ];
    }
    (mkIf config.starlight.proaudio {
      # proaudio extension enabled!
      environment.systemPackages = with pkgs; [
        jack2 cadence
      ];
    })
  ];
}
