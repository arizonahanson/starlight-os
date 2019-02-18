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
      boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
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
