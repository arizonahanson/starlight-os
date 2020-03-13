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
      default = 4;
      description = ''
        bspwm border radius
        (default 4)
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
  };
  config = lib.mkIf config.starlight.desktop {
    environment = {
      etc = let
        cfg = config.starlight;
        palette = config.starlight.palette;
        theme = config.starlight.theme;
        toRGB = num: elemAt (attrValues palette) num;
      in {
        "X11/Xresources" = {
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
        "zathurarc" = {
          text = ''
            set font "${cfg.fonts.terminalFont} normal 10"
            set default-bg "${toRGB theme.bg}"
            set default-fg "${toRGB theme.fg}"
            set inputbar-bg "${toRGB theme.bg}"
            set inputbar-fg "${toRGB theme.fg}"
            set notification-bg "${toRGB theme.bg}"
            set notification-fg "${toRGB theme.fg}"
            set notification-error-bg "${toRGB theme.bg}"
            set notification-error-fg "${toRGB theme.error}"
            set notification-warning-bg "${toRGB theme.bg}"
            set notification-warning-fg "${toRGB theme.warning}"
            set statusbar-bg "${toRGB theme.bg}"
            set statusbar-fg "${toRGB theme.fg}"
            set completion-bg "${toRGB theme.bg}"
            set completion-fg "${toRGB theme.fg}"
            set completion-group-bg "${toRGB theme.bg-alt}"
            set completion-group-fg "${toRGB theme.fg}"
            set completion-highlight-bg "${toRGB theme.bg}"
            set completion-highlight-fg "${toRGB theme.select}"
            set highlight-color "${toRGB theme.match}"
            set highlight-active-color "${toRGB theme.select}"
            set sandbox "none"
          '';
        };
        "qute/config.py" = {
          text = ''
            c.qt.force_software_rendering = 'chromium'
            c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 ${toRGB theme.bg}, stop:1 ${toRGB theme.bg-alt})'
            c.colors.completion.category.fg = '${toRGB theme.fg}'
            c.colors.completion.category.border.bottom = '${toRGB theme.bg}'
            c.colors.completion.category.border.top = '${toRGB theme.bg}'
            c.colors.completion.fg = ['${toRGB theme.fg}', '${toRGB theme.fg}', '${toRGB theme.fg}']
            c.colors.completion.item.selected.bg = '${toRGB theme.bg}'
            c.colors.completion.item.selected.border.bottom = '${toRGB theme.bg-alt}'
            c.colors.completion.item.selected.border.top = '${toRGB theme.bg-alt}'
            c.colors.completion.item.selected.fg = '${toRGB theme.select}'
            c.colors.completion.item.selected.match.fg = '${toRGB theme.match}'
            c.colors.completion.match.fg = '${toRGB theme.match}'
            c.colors.completion.even.bg = '${toRGB theme.bg}'
            c.colors.completion.odd.bg = '${toRGB theme.bg}'
            c.colors.completion.scrollbar.bg = '${toRGB theme.bg}'
            c.colors.completion.scrollbar.fg = '${toRGB theme.fg}'
            c.colors.downloads.bar.bg = '${toRGB theme.bg}'
            c.colors.downloads.error.bg = '${toRGB theme.error}'
            c.colors.downloads.error.fg = '${toRGB theme.fg}'
            c.colors.downloads.start.bg = '${toRGB theme.bg}'
            c.colors.downloads.start.fg = '${toRGB theme.fg}'
            c.colors.downloads.stop.bg = '${toRGB theme.bg}'
            c.colors.downloads.stop.fg = '${toRGB theme.fg}'
            c.colors.hints.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(148,148,192,0.9), stop:1 rgba(148,148,192,0.6))'
            c.colors.hints.fg = 'black'
            c.colors.hints.match.fg = '${toRGB theme.match}'
            # c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'
            c.colors.keyhint.fg = '${toRGB theme.fg}'
            c.colors.keyhint.suffix.fg = '${toRGB theme.accent}'
            c.colors.messages.error.fg = '${toRGB theme.error}'
            c.colors.messages.error.bg = '${toRGB theme.bg}'
            c.colors.messages.error.border = '${toRGB theme.error}'
            c.colors.messages.info.bg = '${toRGB theme.bg}'
            c.colors.messages.info.fg = '${toRGB theme.fg}'
            c.colors.messages.info.border = '${toRGB theme.bg-alt}'
            c.colors.messages.warning.fg = '${toRGB theme.warning}'
            c.colors.messages.warning.border = '${toRGB theme.warning}'
            c.colors.messages.warning.bg = '${toRGB theme.bg}'
            c.colors.prompts.bg = '${toRGB theme.bg}'
            c.colors.prompts.fg = '${toRGB theme.fg}'
            c.colors.prompts.border = '1px solid ${toRGB theme.bg-alt}'
            c.colors.prompts.selected.bg = '${toRGB theme.bg-alt}'
            c.colors.statusbar.caret.bg = '${toRGB theme.accent}'
            c.colors.statusbar.caret.fg = '${toRGB theme.fg}'
            c.colors.statusbar.caret.selection.bg = '${toRGB theme.bg-alt}'
            c.colors.statusbar.caret.selection.fg = '${toRGB theme.fg}'
            c.colors.statusbar.command.bg = '${toRGB theme.bg}'
            c.colors.statusbar.command.fg = '${toRGB theme.fg}'
            c.colors.statusbar.command.private.bg = '${toRGB theme.bg-alt}'
            c.colors.statusbar.command.private.fg = '${toRGB theme.fg}'
            c.colors.statusbar.insert.bg = '${toRGB theme.bg}'
            c.colors.statusbar.insert.fg = '${toRGB theme.fg}'
            c.colors.statusbar.normal.bg = '${toRGB theme.bg}'
            c.colors.statusbar.normal.fg = '${toRGB theme.fg}'
            c.colors.statusbar.passthrough.bg = '${toRGB theme.bg}'
            c.colors.statusbar.passthrough.fg = '${toRGB theme.fg}'
            c.colors.statusbar.private.bg = '${toRGB theme.bg-alt}'
            c.colors.statusbar.private.fg = '${toRGB theme.fg}'
            c.colors.statusbar.progress.bg = '${toRGB theme.fg}'
            c.colors.statusbar.url.error.fg = '${toRGB theme.error}'
            c.colors.statusbar.url.fg = '${toRGB theme.fg}'
            c.colors.statusbar.url.hover.fg = '${toRGB theme.path}'
            c.colors.statusbar.url.success.http.fg = '${toRGB theme.fg}'
            c.colors.statusbar.url.success.https.fg = '${toRGB theme.fg}'
            c.colors.statusbar.url.warn.fg = '${toRGB theme.warning}'
            c.colors.tabs.bar.bg = '${toRGB theme.bg}'
            c.colors.tabs.even.bg = '${toRGB theme.bg}'
            c.colors.tabs.even.fg = '${toRGB theme.fg}'
            c.colors.tabs.odd.bg = '${toRGB theme.bg}'
            c.colors.tabs.odd.fg = '${toRGB theme.fg}'
            c.colors.tabs.pinned.even.bg = '${toRGB theme.bg}'
            c.colors.tabs.pinned.even.fg = '${toRGB theme.fg}'
            c.colors.tabs.pinned.odd.bg = '${toRGB theme.bg}'
            c.colors.tabs.pinned.odd.fg = '${toRGB theme.fg}'
            c.colors.tabs.pinned.selected.even.bg = '${toRGB theme.bg-alt}'
            c.colors.tabs.pinned.selected.even.fg = '${toRGB theme.fg}'
            c.colors.tabs.pinned.selected.odd.bg = '${toRGB theme.bg-alt}'
            c.colors.tabs.pinned.selected.odd.fg = '${toRGB theme.fg}'
            c.colors.tabs.selected.even.bg = '${toRGB theme.bg-alt}'
            c.colors.tabs.selected.even.fg = '${toRGB theme.fg}'
            c.colors.tabs.selected.odd.bg = '${toRGB theme.bg-alt}'
            c.colors.tabs.selected.odd.fg = '${toRGB theme.fg}'
            c.colors.webpage.bg = 'white'
            c.downloads.location.directory = '$HOME/Downloads'
            c.fonts.hints = 'bold 12pt monospace'
            c.fonts.monospace = '${cfg.fonts.terminalFont}'
            c.fonts.web.family.cursive = 'Dancing Script'
            c.fonts.web.family.fantasy = 'Atomic Age'
            c.fonts.web.family.fixed = '${cfg.fonts.monoFont}'
            c.hints.border = '1px solid ${toRGB theme.bg-alt}'
            c.hints.chars = 'aoeuidhtns'
            c.statusbar.hide = True
            c.tabs.indicator.width = 0
            c.tabs.show = 'multiple'
          '';
        };
      };
      variables = {
        BROWSER = "google-chrome-unstable";
        CM_DIR = "/run/cache";
        CM_LAUNCHER = "cliprofi";
        SSH_AUTH_SOCK = "/run/user/$UID/keyring/ssh";
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
            imagemagick
            clipmenu
            networkmanagerapplet
            xorg.xkill
            xdo
            xsel
            numlockx
            qt5ct
            libsForQt5.qtstyleplugins
            qutebrowser
            zathura
            google-chrome-dev
            (cliprofi)
            (reload-desktop)
            (flatpak-alt)
            (say)
            (with import <nixpkgs> {}; writeShellScriptBin "qute" ''
              qutebrowser  -C /etc/qute/config.py "$@"
            '')
          ];
    };
    hardware.opengl.driSupport32Bit = true;
    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
    };
    programs = {
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
          CM_DIR = "/run/cache";
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
      };
    };
  };
}
