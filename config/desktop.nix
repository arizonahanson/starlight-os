{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./bspwm.nix
    ./mate.nix
    ./polybar.nix
    ./theme.nix
    ./audio.nix
  ];
  options.starlight = {
    desktop = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If enabled, will treat as desktop machine
      '';
    };
    logo = mkOption {
      type = types.str;
      default = "• ";
      description = ''
        Text logo
      '';
    };
    palette = {
      foreground = mkOption {
        type = types.str;
        default = "#c7c7c7";
        description = ''
          Foreground color
        '';
      };
      foreground-alt = mkOption {
        type = types.str;
        default = "#787878";
        description = ''
          Alternate foreground color
        '';
      };
      background = mkOption {
        type = types.str;
        default = "#212121";
        description = ''
          Background color
        '';
      };
      background-alt = mkOption {
        type = types.str;
        default = "#404040";
        description = ''
          Background color
        '';
      };
      color0 = mkOption {
        type = types.str;
        default = "#212121";
        description = ''
          color 0 (black)
        '';
      };
      color1 = mkOption {
        type = types.str;
        default = "#cc6666";
        description = ''
          color 1 (red)
        '';
      };
      color2 = mkOption {
        type = types.str;
        default = "#638f63";
        description = ''
          color 2 (green)
        '';
      };
      color3 = mkOption {
        type = types.str;
        default = "#8f7542";
        description = ''
          color 3 (brown)
        '';
      };
      color4 = mkOption {
        type = types.str;
        default = "#59748f";
        description = ''
          color 4 (blue)
        '';
      };
      color5 = mkOption {
        type = types.str;
        default = "#85678f";
        description = ''
          color 5 (magenta)
        '';
      };
      color6 = mkOption {
        type = types.str;
        default = "#5e8d87";
        description = ''
          color 6 (cyan)
        '';
      };
      color7 = mkOption {
        type = types.str;
        default = "#787878";
        description = ''
          color 7 (white)
        '';
      };
      color8 = mkOption {
        type = types.str;
        default = "#404040";
        description = ''
          color 8 (dark gray)
        '';
      };
      color9 = mkOption {
        type = types.str;
        default = "#de985f";
        description = ''
          color 9 (orange)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#85cc85";
        description = ''
          color 10 (bright green)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#f0c674";
        description = ''
          color 11 (yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#8fadcc";
        description = ''
          color 12 (bright blue)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#b093ba";
        description = ''
          color 13 (bright magenta)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#8abeb7";
        description = ''
          color 14 (bright cyan)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#c7c7c7";
        description = ''
          color 15 (bright white)
        '';
      };
    };
  };
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages = with pkgs; [
      sxhkd rofi-unwrapped libnotify feh clipmenu
      chromium networkmanagerapplet
      xdg-desktop-portal-gtk xorg.xkill xdo xsel
      (termite.override {
        configFile = "/etc/termite.conf";
      })
      (with import <nixpkgs> {}; writeShellScriptBin "cliprofi" ''
        ${rofi-unwrapped}/bin/rofi -p  -dmenu -normal-window $@
      '')
      (with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
        pkill -USR1 -x sxhkd
        pkill -USR1 -x polybar
        ${libnotify}/bin/notify-send -i keyboard 'Reloaded desktop' 'desktop bar and key-bindings reloaded'
      '')
      (with import <nixpkgs> {}; writeShellScriptBin "terminal" ''
        CLASS_NAME="terminal"
        # does term with CLASS_NAME exist?
        if xdo id -N "$CLASS_NAME">/dev/null; then
          # focus, move to current desktop the existing term with CLASS_NAME
          for NODE_ID in $(xdo id -N $CLASS_NAME); do
            bspc node $NODE_ID -d focused -m focused
            bspc node -f $NODE_ID
          done
        else
          # create new term with CLASS_NAME
          # create new tmux session, or attach if exists
          termite -e "tmux-session '${config.starlight.logo}'" --class="$CLASS_NAME"
        fi
      '')
      (with import <nixpkgs> {}; writeShellScriptBin "flatpak" ''
        ${flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        ${flatpak}/bin/flatpak $@
      '')
    ];
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
    environment.variables = {
      TERMINAL = "termite";
      BROWSER = "chromium";
      CM_LAUNCHER = "cliprofi";
      SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
    };
    environment.etc."termite.conf" = let palette = config.starlight.palette; in {
      mode = "0644";
      text = ''
        [options]
        font = Share Tech Mono 16
        allow_bold = false
  
        [colors]
  
        # special
        foreground      = ${palette.foreground}
        foreground_bold = ${palette.foreground}
        cursor          = ${palette.foreground}
        background      = ${palette.background}
  
        # black
        color0  = ${palette.color0}
        color8  = ${palette.color8}
  
        # red
        color1  = ${palette.color1}
        color9  = ${palette.color9}
  
        # green
        color2  = ${palette.color2}
        color10 = ${palette.color10}
  
        # yellow
        color3  = ${palette.color3}
        color11 = ${palette.color11}
  
        # blue
        color4  = ${palette.color4}
        color12 = ${palette.color12}
  
        # magenta
        color5  = ${palette.color5}
        color13 = ${palette.color13}
  
        # cyan
        color6  = ${palette.color6}
        color14 = ${palette.color14}
  
        # white
        color7  = ${palette.color7}
        color15 = ${palette.color15}
      '';
    };
    environment.etc."ld-nix.so.preload" = if config.virtualisation.virtualbox.guest.enable then {
      text = ''
        ${pkgs.linuxPackages.virtualboxGuestAdditions}/lib/VBoxOGL.so
      '';
    } else {
      text = "";
    };
  
    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
    };
    networking.networkmanager = {
      enable = true;
    };
    fonts.fonts = with pkgs; [
      font-awesome_5
      google-fonts
      noto-fonts-emoji
    ];
    fonts.fontconfig = {
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
      useEmbeddedBitmaps = false;
    };
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    };
    programs.chromium = {
      enable = true;
      extraOpts = {
        DiskCacheDir = "/tmp/.chromium-\${user_name}";
      };
    };
    # flatpak
    services.flatpak = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
    # keyring
    services.gnome3.seahorse.enable = true;
    services.gnome3.gnome-keyring.enable = true;
    services.haveged.enable = true;
    programs.zsh.interactiveShellInit = ''
      export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
    '';
  
    users.users.admin.extraGroups = [ "networkmanager" ];
  
    # Enable the X11 windowing system.
    hardware.opengl.driSupport32Bit = true;
    boot.plymouth = {
      enable = true;
    };
    services.xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support.
      libinput.enable = true;
      updateDbusEnvironment = true;
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
    };
    services.compton = {
      enable = true;
      shadow = true;
      shadowOffsets = [ (-9) (-3) ];
      shadowExclude = [
        "name = 'Polybar tray window'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      shadowOpacity = "0.5";
      extraOptions = ''
        shadow-radius = 6;
      '';
    };
    environment.etc."X11/Xresources" = let palette = config.starlight.palette; in {
      text = ''
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
        rofi.color-urgent: ${palette.background},${palette.color1},${palette.background},${palette.background},${palette.color1}
        rofi.color-active: ${palette.background},${palette.foreground-alt},${palette.background},${palette.background},${palette.foreground}
        rofi.color-window: ${palette.background},${palette.background},${palette.background}
        rofi.display-drun: 
        rofi.display-run: 
        rofi.display-window: 
        rofi.display-ssh: 
        rofi.display-combi: 
        rofi.combi-modi: window,run,drun
        rofi.monitor: -1
  
        ! special
        *.foreground:   ${palette.foreground}
        *.cursorColor:  ${palette.foreground}
        *.background:   ${palette.background}
  
        ! black
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
  };
}
