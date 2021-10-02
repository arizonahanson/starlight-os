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
          fluidsynth
          soundfont-fluid
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
          VST_PATH = "/nix/var/nix/profiles/default/lib/vst:~/.nix-profile/lib/vst:~/.vst";
          LXVST_PATH = "/nix/var/nix/profiles/default/lib/lxvst:~/.nix-profile/lib/lxvst:~/.lxvst";
          LADSPA_PATH = "/nix/var/nix/profiles/default/lib/ladspa:~/.nix-profile/lib/ladspa:~/.ladspa";
          LV2_PATH = "/nix/var/nix/profiles/default/lib/lv2:~/.nix-profile/lib/lv2:~/.lv2";
          DSSI_PATH = "/nix/var/nix/profiles/default/lib/dssi:~/.nix-profile/lib/dssi:~/.dssi";
        };
        powerManagement.cpuFreqGovernor = "performance";
        programs.zsh.shellAliases = with pkgs; {
          fluid = "${fluidsynth}/bin/fluidsynth ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
        };
      }
    )
  ];
}
