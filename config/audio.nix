{ config, lib, pkgs, ... }:

with lib;

{
  options.starlight.proaudio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, will use jack proaudio setup
      '';
    };
    device = mkOption {
      type = types.str;
      default = "none";
      description = ''
        ALSA device
      '';
    };
    capture = mkOption {
      type = types.str;
      default = "none";
      description = ''
        ALSA capture device
      '';
    };
    playback = mkOption {
      type = types.str;
      default = "none";
      description = ''
        ALSA playback device
      '';
    };
    rate = mkOption {
      type = types.int;
      default = 44100;
      description = ''
        sample rate (44100)
      '';
    };
    periods = mkOption {
      type = types.int;
      default = 2;
      description = ''
        number of periods (2)
      '';
    };
    frames = mkOption {
      type = types.int;
      default = 1024;
      description = ''
        frames (1024)
      '';
    };
  };
    
  config = mkMerge [
    (mkIf config.starlight.desktop {
      # Enable sound.
      sound.enable = true;
      users.users.admin.extraGroups = [ "audio" ];
      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        daemon.config = {
          default-sample-format = "s24-32le";
          default-sample-rate = "44100";
        };
      };
      environment.systemPackages = with pkgs; [
        playerctl sound-theme-freedesktop
      ];
    })
    (mkIf config.starlight.proaudio.enable {
      # proaudio extension enabled!
      security.rtkit.enable = true;
      boot = {
        kernelModules = [ "snd-seq" "snd-rawmidi" ];
        kernel.sysctl = { "vm.swappiness" = 10; "fs.inotify.max_user_watches" = 524288; };
        kernelParams = [ "threadirq" ];
        postBootCommands = ''
          echo 2048 > /sys/class/rtc/rtc0/max_user_freq
          echo 2048 > /proc/sys/dev/hpet/max-user-freq
          setpci -v -d *:* latency_timer=b0
          setpci -v -s ''$(lspci | grep -i audio | awk '{print ''$1}') latency_timer=ff
        '';
      };
      powerManagement.cpuFreqGovernor = "performance";
      fileSystems."/" = { options = [ "noatime" ]; };
      security.pam.loginLimits = [
        { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
        { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
        { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
        { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
      ];
      services = {
        udev = {
          extraRules = ''
            KERNEL=="rtc0", GROUP="audio"
            KERNEL=="hpet", GROUP="audio"
          '';
        };
        cron.enable = false;
      };
      systemd.user.services.pulseaudio.environment.DISPLAY = ":0";
      systemd.user.services.autojack = let cfg = config.starlight.proaudio; in {
        serviceConfig.Type = "simple";
        wantedBy = [ "default.target" ];
        path = [ pkgs.jack2 pkgs.a2jmidid pkgs.pulseaudioFull ];
        environment = {
          DISPLAY = ":0";
        };
        after = [ "pulseaudio.service" ];
        enable = true;
        script = ''
          sleep 5
          jack_control ds alsa
          jack_control dps device '${cfg.device}'
          jack_control dps capture '${cfg.capture}'
          jack_control dps playback '${cfg.playback}'
          jack_control dps rate ${toString cfg.rate}
          jack_control dps nperiods ${toString cfg.periods}
          jack_control dps period ${toString cfg.frames}
          jack_control start
          a2j_control ehw
          a2j_control start
          sleep infinity
        '';
        preStop = ''
          a2j_control exit
          jack_control exit
        '';
      };
      environment.variables = {
        VST_PATH = "/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst";
        LXVST_PATH = "/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst";
        LADSPA_PATH = "/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa";
        LV2_PATH = "/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2";
        DSSI_PATH = "/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi";
      };
      programs.zsh.shellAliases = with pkgs; {
        fluidsynth = "${fluidsynth}/bin/fluidsynth ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
      };
      environment.systemPackages = with pkgs; [
        jack2 a2jmidid patchage fluidsynth soundfont-fluid alsaLib
      ];
    })
  ];
}
