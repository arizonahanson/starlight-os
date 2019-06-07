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
      default = "⋆ ";
      description = ''
        Text logo
      '';
    };
    palette = {
      foreground = mkOption {
        type = types.str;
        default = "#C7C7C7";
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
      cursor = mkOption {
        type = types.str;
        default = "#9E9E9E";
        description = ''
          Cursor color
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
        default = "#CC6666";
        description = ''
          color 1 (red)
        '';
      };
      color2 = mkOption {
        type = types.str;
        default = "#638F63";
        description = ''
          color 2 (green)
        '';
      };
      color3 = mkOption {
        type = types.str;
        default = "#8F8842";
        description = ''
          color 3 (brown)
        '';
      };
      color4 = mkOption {
        type = types.str;
        default = "#59748F";
        description = ''
          color 4 (blue)
        '';
      };
      color5 = mkOption {
        type = types.str;
        default = "#85678F";
        description = ''
          color 5 (magenta)
        '';
      };
      color6 = mkOption {
        type = types.str;
        default = "#5E8D87";
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
        default = "#DE985F";
        description = ''
          color 9 (orange)
        '';
      };
      color10 = mkOption {
        type = types.str;
        default = "#85CC85";
        description = ''
          color 10 (bright green)
        '';
      };
      color11 = mkOption {
        type = types.str;
        default = "#D9CF69";
        description = ''
          color 11 (yellow)
        '';
      };
      color12 = mkOption {
        type = types.str;
        default = "#8FADCC";
        description = ''
          color 12 (bright blue)
        '';
      };
      color13 = mkOption {
        type = types.str;
        default = "#B093BA";
        description = ''
          color 13 (bright magenta)
        '';
      };
      color14 = mkOption {
        type = types.str;
        default = "#8ABEB7";
        description = ''
          color 14 (bright cyan)
        '';
      };
      color15 = mkOption {
        type = types.str;
        default = "#C7C7C7";
        description = ''
          color 15 (bright white)
        '';
      };
    };
    dwarf-fortress = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Include dwarf fortress
      '';
    };
  };
  config = lib.mkIf config.starlight.desktop {
    environment.systemPackages = with pkgs; [
      sxhkd rofi-unwrapped libnotify feh clipmenu
      chromium networkmanagerapplet
      xdg-desktop-portal-gtk xorg.xkill xdo xsel
      (with import <nixpkgs> {}; writeShellScriptBin "cliprofi" ''
        ${rofi-unwrapped}/bin/rofi -p  -dmenu -normal-window $@
      '')
      (with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
        pkill -USR1 -x sxhkd
        pkill -USR1 -x polybar
        pkill -USR1 -x compton
        ${libnotify}/bin/notify-send -i keyboard 'Reloaded desktop' 'desktop bar and key-bindings reloaded'
      '')
      (with import <nixpkgs> {}; writeShellScriptBin "flatpak" ''
        ${flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        ${flatpak}/bin/flatpak $@
      '')
    ] 
    ++ lib.optional config.starlight.dwarf-fortress (dwarf-fortress-packages.dwarf-fortress-full.override {
      enableIntro = false;
      enableTWBT = true;
      theme = dwarf-fortress-packages.themes.wanderlust;
    });
    # flatpak
    services.flatpak = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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
    # chromium profile
    programs.chromium = {
      enable = true;
      extraOpts = {
        DiskCacheDir = "/tmp/.chromium-\${user_name}";
      };
    };
    # keyring
    services.gnome3.seahorse.enable = true;
    services.gnome3.gnome-keyring.enable = true;
    environment.variables = {
      BROWSER = "chromium";
      CM_LAUNCHER = "cliprofi";
      SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
    };
    # SSH_ASKPASS already defined
    programs.zsh.interactiveShellInit = ''
      export SSH_ASKPASS="${pkgs.gnome3.seahorse}/libexec/seahorse/ssh-askpass"
    '';
    xdg = {
      autostart.enable = true;
      icons.enable = true;
      menus.enable = true;
      mime.enable = true;
    };
    users.users.admin.extraGroups = [ "networkmanager" ];
    networking.networkmanager = {
      enable = true;
    };
    fonts.fonts = with pkgs; [
      font-awesome_5
      google-fonts
      noto-fonts-emoji
    ];
    fonts.fontconfig = {
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
      useEmbeddedBitmaps = false;
    };
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    };
    # more entropy
    services.haveged.enable = true;
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
      shadowOffsets = [ (-9) (0) ];
      shadowExclude = [
        "name = 'Polybar tray window'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      shadowOpacity = "0.5";
      extraOptions = ''
        shadow-radius = 9;
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
        *.cursorColor:  ${palette.cursor}
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
