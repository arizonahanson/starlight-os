{ config, lib, pkgs, ... }:

with lib;

{
  config = mkMerge [
    (
      mkIf config.starlight.desktop {
        environment.systemPackages = with pkgs; [
          playerctl
          sound-theme-freedesktop
          patchage
          alsaUtils
        ];
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
          media-session.enable = true;
        };
        environment.variables = {
          VST_PATH = "/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst";
          LXVST_PATH = "/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst";
          LADSPA_PATH = "/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa";
          LV2_PATH = "/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2";
          DSSI_PATH = "/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi";
        };
        powerManagement.cpuFreqGovernor = "performance";
        /*programs.zsh.shellAliases = with pkgs; {
          fluidsynth = "${fluidsynth}/bin/fluidsynth ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
          };*/
      }
    )
  ];
}
