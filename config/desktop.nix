{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./bspwm.nix
    ./mate.nix
    ./polybar.nix
    ./theme.nix
    ./audio.nix
    ./terminal.nix
    ./touchscreen.nix
    ./colors.nix
    ./fonts.nix
  ];
  options.starlight = {
    desktop = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If enabled, will treat as desktop machine
      '';
    };
    pointerSize = mkOption {
      type = types.int;
      default = 32;
      description = ''
        XCursor size
        (default 32)
      '';
    };
    logo = mkOption {
      type = types.str;
      default = " ";
      description = ''
        Text logo
      '';
    };
    borderWidth = mkOption {
      type = types.int;
      default = 2;
      description = ''
        bspwm border radius
        (default 2)
      '';
    };
    shadowOpacity = mkOption {
      type = types.float;
      default = 0.75;
      description = ''
        compton shadow opacity
        (default 0.75)
      '';
    };
    shadowRadius = mkOption {
      type = types.int;
      default = 16;
      description = ''
        compton shadow radius
        (default 16)
      '';
    };
    opacity = mkOption {
      type = types.int;
      default = 95;
      description = ''
        compton terminal opacity
        (default 95)
      '';
    };
  };
  config = lib.mkIf config.starlight.desktop {
    environment = {
      etc."X11/Xresources" = let
        cfg = config.starlight;
        palette = config.starlight.palette;
        theme = config.starlight.theme;
        toRGB = num: elemAt (attrValues palette) num;
      in
        {
          text = ''
            ! Xcursor
            Xcursor.theme: Bibata_Oil
            Xcursor.size:  ${toString config.starlight.pointerSize}

            ! XFT
            Xft.antialias: 1
            Xft.autohint: 0
            Xft.dpi: 96
            Xft.hinting: 1
            Xft.hintstyle: hintslight
            Xft.lcdfilter: lcddefault
            Xft.rgba: rgb

            ! ROFI
            rofi.font:              ${cfg.fonts.uiFont} ${toString cfg.fonts.fontSize}
            rofi.modi:              window,run,drun,combi
            rofi.width:             38
            rofi.lines:             5
            rofi.columns:           1
            ! "border width"
            rofi.bw:                2
            rofi.location:          0
            rofi.padding:           12
            rofi.yoffset:           0
            rofi.xoffset:           0
            rofi.fixed-num-lines:   true
            rofi.terminal:          termite
            rofi.run-shell-command:  {terminal} -e '{cmd}'
            ! "margin between rows"
            rofi.line-margin:       2
            ! "separator style (none, dash, solid)"
            rofi.separator-style:   none
            rofi.hide-scrollbar:    true
            rofi.fullscreen:        false
            rofi.fake-transparency: false
            ! "scrolling method. (0: Page, 1: Centered)"
            rofi.scroll-method:     1
            ! State:           'bg',   'fg',   'bgalt','hlbg', 'hlfg'
            rofi.color-normal: ${toRGB theme.bg},${toRGB theme.bg-alt},${toRGB theme.bg},${toRGB theme.bg},${toRGB theme.fg}
            rofi.color-urgent: ${toRGB theme.bg},${toRGB theme.info},${toRGB theme.bg},${toRGB theme.bg},${toRGB theme.info}
            rofi.color-active: ${toRGB theme.bg},${toRGB theme.fg-alt},${toRGB theme.bg},${toRGB theme.bg},${toRGB theme.fg}
            rofi.color-window: ${toRGB theme.bg},${toRGB theme.bg},${toRGB theme.bg}
            rofi.display-drun: 
            rofi.display-run: 
            rofi.display-window: 
            rofi.display-ssh: 
            rofi.display-combi: 
            rofi.combi-modi: window,run,drun
            rofi.monitor: -1

            *.foreground:   ${toRGB theme.fg}
            *.background:   ${toRGB theme.bg}
            *.cursorColor:  ${palette.cursor}
            *.color0:       ${palette.color00}
            *.color8:       ${palette.color08}
            ! red
            *.color1:       ${palette.color01}
            *.color9:       ${palette.color09}
            ! green
            *.color2:       ${palette.color02}
            *.color10:      ${palette.color10}
            ! yellow
            *.color3:       ${palette.color03}
            *.color11:      ${palette.color11}
            ! blue
            *.color4:       ${palette.color04}
            *.color12:      ${palette.color12}
            ! magenta
            *.color5:       ${palette.color05}
            *.color13:      ${palette.color13}
            ! cyan
            *.color6:       ${palette.color06}
            *.color14:      ${palette.color14}
            ! white
            *.color7:       ${palette.color07}
            *.color15:      ${palette.color15}
          '';
        };
      variables = {
        BROWSER = "chromium";
        CM_DIR = "/tmp";
        CM_LAUNCHER = "cliprofi";
        SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
        XCURSOR_THEME = "Bibata_Oil";
        QT_QPA_PLATFORMTHEME = "gtk2";
      };
      systemPackages =
        let
          cliprofi = (
            with import <nixpkgs> {}; writeShellScriptBin "cliprofi" ''
              ${rofi-unwrapped}/bin/rofi -p  -dmenu -normal-window $@
            ''
          );
          reload-desktop = (
            with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
              ${procps}/bin/pkill -USR1 -x sxhkd
              ${procps}/bin/pkill -TERM -x compton
              ${procps}/bin/pkill -TERM -x polybar
              ${bspwm}/bin/bspc wm -r
              say 'Reloaded desktop' 'Desktop components have been reloaded'
            ''
          );
          flatpak-alt = (
            with import <nixpkgs> {}; writeShellScriptBin "flatpak" ''
              ${flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
              ${flatpak}/bin/flatpak "$@"
            ''
          );
          say = (
            with import <nixpkgs> {}; writeShellScriptBin "say" ''
              ${libnotify}/bin/notify-send -i info "$@"
            ''
          );
        in
          with pkgs; [
            sxhkd
            rofi-unwrapped
            libnotify
            feh
            clipmenu
            networkmanagerapplet
            xdg-desktop-portal-gtk
            xorg.xkill
            xdo
            xsel
            numlockx
            qt5ct
            libsForQt5.qtstyleplugins
            chromium
            (cliprofi)
            (reload-desktop)
            (flatpak-alt)
            (say)
          ];
    };
    hardware.opengl.driSupport32Bit = true;
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    };
    programs = {
      # chromium profile
      chromium = {
        enable = true;
        extraOpts = {
          DiskCacheDir = "/tmp/.chromium-\${user_name}";
        };
      };
      seahorse.enable = true;
      # SSH_ASKPASS already defined
      zsh.interactiveShellInit = ''
        export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
      '';
    };
    services = {
      compton = let cfg = config.starlight; in
        {
          enable = true;
          shadow = true;
          shadowOffsets = [ (cfg.shadowRadius * -1) (cfg.shadowRadius / -2) ];
          shadowOpacity = toString cfg.shadowOpacity;
          settings = {
            shadow-radius = cfg.shadowRadius;
          };
          shadowExclude = [
            "name = 'Polybar tray window'"
            "_GTK_FRAME_EXTENTS@:c"
          ];
          fade = true;
          fadeDelta = 3;
          fadeSteps = [ "0.03125" "0.03125" ];
          opacityRules = [
            "${toString cfg.opacity}:class_g = 'terminal'"
            "${toString cfg.opacity}:class_g = 'Polybar'"
            "${toString ((cfg.opacity + 100) / 2)}:class_g = 'Rofi'"
          ];
        };
      flatpak = {
        enable = true;
      };
      # keyring
      gnome3 = {
        gnome-keyring.enable = true;
      };
      # more entropy
      haveged.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          sddm = {
            enable = true;
            autoLogin = {
              enable = true;
              user = "admin";
              relogin = false;
            };
          };
          setupCommands = ''
            xset -dpms
            xset s off
          '';
        };
        layout = "us";
        # Enable touchpad support.
        libinput.enable = true;
        updateDbusEnvironment = true;
      };
    };
    systemd.user.services = {
      clipmenud = {
        serviceConfig.Type = "simple";
        wantedBy = [ "default.target" ];
        environment = {
          DISPLAY = ":0";
          CM_DIR = "/tmp";
        };
        path = [ pkgs.clipmenu ];
        script = ''
          ${pkgs.clipmenu}/bin/clipmenud
        '';
      };
    };
    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };
    };
  };
}
