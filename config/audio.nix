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
      users.users.admin.extraGroups = [ "audio" ];
      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        support32Bit = true;
      };
      environment.systemPackages = with pkgs; [
        playerctl sound-theme-freedesktop
      ];
    }
    (mkIf config.starlight.proaudio {
      # proaudio extension enabled!
      security.rtkit.enable = true;
      boot = {
        kernelModules = [ "snd-seq" "snd-rawmidi" ];
        kernel.sysctl = { "vm.swappiness" = 10; "fs.inotify.max_user_watches" = 524288; };
        kernelParams = [ "threadirq" ];
        /*kernelPackages = let rtKernel = pkgs.linuxPackagesFor (pkgs.linux.override {
          extraConfig = ''
            PREEMPT_RT_FULL? y
            PREEMPT y
            IOSCHED_DEADLINE y
            DEFAULT_DEADLINE y
            DEFAULT_IOSCHED "deadline"
            HPET_TIMER y
            CPU_FREQ n
            TREE_RCU_TRACE n
          '';
          }) pkgs.linuxPackages;
        in rtKernel;

        postBootCommands = ''
          echo 2048 > /sys/class/rtc/rtc0/max_user_freq
          echo 2048 > /proc/sys/dev/hpet/max-user-freq
          setpci -v -d *:* latency_timer=b0
          setpci -v -s ''$(lspci | grep -i audio | awk '{print ''$1}') latency_timer=ff
        '';*/
      };
      powerManagement.cpuFreqGovernor = "performance";
      #fileSystems."/" = { options = "noatime errors=remount-ro"; };
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
        cron.enable =false;
      };
      environment.interactiveShellInit = ''
        export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
        export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
        export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
        export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
        export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
      '';
      environment.systemPackages = with pkgs; [
        jack2 a2jmidid patchage qjackctl
        # cadence works, but not claudia (no ladish)
        /*(cadence.overrideAttrs (oldAttrs: {
          propagatedBuildInputs = [
            (python37Packages.pyqt5.overrideAttrs (oldAttrs: {
              configurePhase = ''
                runHook preConfigure
                mkdir -p $out
                lndir ${dbus.dev} $out
                lndir ${dbus.lib}/lib/dbus-1.0/include $out/include/dbus-1.0
                lndir ${python37Packages.dbus-python} $out
                rm -rf "$out/nix-support"
                export PYTHONPATH=$PYTHONPATH:$out/${pkgs.python37.sitePackages}
                ${pkgs.python37.executable} configure.py  -w \
                  --confirm-license \
                  --dbus=$out/include/dbus-1.0 \
                  --no-qml-plugin \
                  --bindir=$out/bin \
                  --destdir=$out/${pkgs.python37.sitePackages} \
                  --stubsdir=$out/${pkgs.python37.sitePackages}/PyQt5 \
                  --sipdir=$out/share/sip/PyQt5 \
                  --designer-plugindir=$out/plugins/designer
                runHook postConfigure
              '';
            }))
          ];
        }))*/
      ];
    })
  ];
}
