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
  ];
  options.starlight = {
    desktop = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If enabled, will treat as desktop machine
      '';
    };
    cursorSize = mkOption {
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
    shadowRadius = mkOption {
      type = types.int;
      default = 16;
      description = ''
        compton shadow radius
        (default 16)
      '';
    };
  };
  config = lib.mkIf config.starlight.desktop {
    environment = {
      etc."X11/Xresources" = let palette = config.starlight.palette; in {
        text = ''
          ! Xcursor
          Xcursor.theme: Bibata_Oil
          Xcursor.size:  ${toString config.starlight.cursorSize}

          ! XFT
          Xft.antialias: 1
          Xft.autohint: 1
          Xft.dpi: 96
          Xft.hinting: 1
          Xft.hintstyle: hintslight
          Xft.lcdfilter: lcddefault
          Xft.rgba: rgb
    
          ! ROFI
          rofi.font:              Share Tech 16
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
          rofi.color-normal: ${palette.background},${palette.background-alt},${palette.background},${palette.background},${palette.foreground}
          rofi.color-urgent: ${palette.background},${palette.info},${palette.background},${palette.background},${palette.info}
          rofi.color-active: ${palette.background},${palette.foreground-alt},${palette.background},${palette.background},${palette.foreground}
          rofi.color-window: ${palette.background},${palette.background},${palette.background}
          rofi.display-drun: 
          rofi.display-run: 
          rofi.display-window: 
          rofi.display-ssh: 
          rofi.display-combi: 
          rofi.combi-modi: window,run,drun
          rofi.monitor: -1
    
          *.foreground:   ${palette.foreground}
          *.cursorColor:  ${palette.cursor}
          *.background:   ${palette.background}
          *.color0:       ${palette.color0}
          *.color8:       ${palette.color8}
          ! red
          *.color1:       ${palette.color1}
          *.color9:       ${palette.color9}
          ! green
          *.color2:       ${palette.color2}
          *.color10:      ${palette.color10}
          ! yellow
          *.color3:       ${palette.color3}
          *.color11:      ${palette.color11}
          ! blue
          *.color4:       ${palette.color4}
          *.color12:      ${palette.color12}
          ! magenta
          *.color5:       ${palette.color5}
          *.color13:      ${palette.color13}
          ! cyan
          *.color6:       ${palette.color6}
          *.color14:      ${palette.color14}
          ! white
          *.color7:       ${palette.color7}
          *.color15:      ${palette.color15}
        '';
      };
      variables = {
        BROWSER = "chromium";
        CM_LAUNCHER = "cliprofi";
        SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
        XCURSOR_THEME="Bibata_Oil";
      };
      systemPackages = 
        let 
          cliprofi = (with import <nixpkgs> {}; writeShellScriptBin "cliprofi" ''
            ${rofi-unwrapped}/bin/rofi -p  -dmenu -normal-window $@
          '');
          reload-desktop = (with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
            ${procps}/bin/pkill -USR1 -x sxhkd
            ${procps}/bin/pkill -TERM -x compton
            ${procps}/bin/pkill -TERM -x polybar
            ${bspwm}/bin/bspc wm -r
            say 'Reloaded desktop' 'Desktop components have been reloaded'
          '');
          flatpak-alt = (with import <nixpkgs> {}; writeShellScriptBin "flatpak" ''
            ${flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            ${flatpak}/bin/flatpak "$@"
          '');
          say = (with import <nixpkgs> {}; writeShellScriptBin "say" ''
            ${libnotify}/bin/notify-send -i star "$@"
          '');
        in with pkgs; [
          sxhkd rofi-unwrapped libnotify feh clipmenu networkmanagerapplet
          xdg-desktop-portal-gtk xorg.xkill xdo xsel chromium
          (cliprofi) (reload-desktop) (flatpak-alt) (say)
        ];
    };
    fonts = {
      fonts = with pkgs; [
        google-fonts
        font-awesome_5
        noto-fonts-emoji
      ];
      fontconfig = {
        enable = true;
        localConf = ''
          <fontconfig>
            <match target="pattern">
                <edit name="family" mode="prepend_first">
                      <string>DejaVu Sans</string>
                </edit>
            </match>
            <match target="pattern">
                <edit name="family" mode="prepend_first">
                      <string>Noto Emoji</string>
                </edit>
            </match>
            <match target="pattern">
                <edit name="family" mode="prepend_first">
                      <string>Font Awesome 5 Free Solid</string>
                </edit>
            </match>
          </fontconfig>
        '';
      };
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
      # SSH_ASKPASS already defined
      zsh.interactiveShellInit = ''
        export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
      '';
    };
    services = {
      compton = let shadowRadius = config.starlight.shadowRadius; in {
        enable = true;
        shadow = true;
        shadowOffsets = [ (shadowRadius * -1) (shadowRadius / -2) ];
        shadowExclude = [
          "name = 'Polybar tray window'"
          "_GTK_FRAME_EXTENTS@:c"
        ];
        shadowOpacity = "0.5";
        settings = {
          shadow-radius = shadowRadius;
        };
      };
      flatpak = {
        enable = true;
      };
      # keyring
      gnome3 = {
        seahorse.enable = true;
        gnome-keyring.enable = true;
      };
      # more entropy
      haveged.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          sddm = {
            enable = true;
            autoNumlock = true;
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
