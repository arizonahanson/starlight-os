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
        "qute/config.py" = {
          text = ''
            ## Background color of the completion widget category headers.
            c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 ${toRGB theme.bg-alt}, stop:1 ${toRGB theme.bg})'

            ## Bottom border color of the completion widget category headers.
            c.colors.completion.category.border.bottom = '${toRGB theme.bg}'

            ## Top border color of the completion widget category headers.
            c.colors.completion.category.border.top = '${toRGB theme.bg}'

            ## Foreground color of completion widget category headers.
            c.colors.completion.category.fg = '${toRGB theme.fg}'

            ## Text color of the completion widget. May be a single color to use for
            ## all columns or a list of three colors, one for each column.
            c.colors.completion.fg = ['${toRGB theme.fg}', '${toRGB theme.fg}', '${toRGB theme.fg}']

            ## Background color of the selected completion item.
            c.colors.completion.item.selected.bg = '${toRGB theme.select}'

            ## Bottom border color of the selected completion item.
            c.colors.completion.item.selected.border.bottom = '${toRGB theme.bg-alt}'

            ## Top border color of the selected completion item.
            c.colors.completion.item.selected.border.top = '${toRGB theme.bg-alt}'

            ## Foreground color of the selected completion item.
            c.colors.completion.item.selected.fg = '${toRGB theme.bg}'

            ## Foreground color of the matched text in the selected completion item.
            c.colors.completion.item.selected.match.fg = '${toRGB theme.match}'

            ## Foreground color of the matched text in the completion.
            c.colors.completion.match.fg = '${toRGB theme.match}'

            ## Background color of the completion widget for even rows.
            c.colors.completion.even.bg = '${toRGB theme.bg}'

            ## Background color of the completion widget for odd rows.
            c.colors.completion.odd.bg = '${toRGB theme.bg}'

            ## Color of the scrollbar in the completion view.
            c.colors.completion.scrollbar.bg = '${toRGB theme.bg}'

            ## Color of the scrollbar handle in the completion view.
            c.colors.completion.scrollbar.fg = '${toRGB theme.fg}'

            ## Background color for the download bar.
            c.colors.downloads.bar.bg = '${toRGB theme.bg}'

            ## Background color for downloads with errors.
            c.colors.downloads.error.bg = '${toRGB theme.error}'

            ## Foreground color for downloads with errors.
            c.colors.downloads.error.fg = '${toRGB theme.fg}'

            ## Color gradient start for download backgrounds.
            c.colors.downloads.start.bg = '${toRGB theme.bg}'

            ## Color gradient start for download text.
            c.colors.downloads.start.fg = '${toRGB theme.fg}'

            ## Color gradient stop for download backgrounds.
            c.colors.downloads.stop.bg = '${toRGB theme.bg}'

            ## Color gradient end for download text.
            c.colors.downloads.stop.fg = '${toRGB theme.fg}'

            ## Background color for hints. Note that you can use a `rgba(...)` value
            ## for transparency.
            c.colors.hints.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 ${toRGB theme.bg-alt}, stop:1 rgba(0,0,0,0.5))'

            ## Font color for hints.
            c.colors.hints.fg = '${toRGB theme.bg}'

            ## Font color for the matched part of hints.
            c.colors.hints.match.fg = '${toRGB theme.match}'

            ## Background color of the keyhint widget.
            # c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'

            ## Text color for the keyhint widget.
            c.colors.keyhint.fg = '${toRGB theme.fg}'

            ## Highlight color for keys to complete the current keychain.
            c.colors.keyhint.suffix.fg = '${toRGB theme.accent}'

            ## Background color of an error message.
            c.colors.messages.error.bg = '${toRGB theme.error}'

            ## Border color of an error message.
            c.colors.messages.error.border = '${toRGB theme.error}'

            ## Foreground color of an error message.
            c.colors.messages.error.fg = '${toRGB theme.fg}'

            ## Background color of an info message.
            c.colors.messages.info.bg = '${toRGB theme.bg}'

            ## Border color of an info message.
            c.colors.messages.info.border = '${toRGB theme.bg-alt}'

            ## Foreground color of an info message.
            c.colors.messages.info.fg = '${toRGB theme.fg}'

            ## Background color of a warning message.
            c.colors.messages.warning.bg = '${toRGB theme.warning}'

            ## Border color of a warning message.
            c.colors.messages.warning.border = '${toRGB theme.warning}'

            ## Foreground color of a warning message.
            c.colors.messages.warning.fg = '${toRGB theme.fg}'

            ## Background color for prompts.
            c.colors.prompts.bg = '${toRGB theme.bg-alt}'

            ## Border used around UI elements in prompts.
            c.colors.prompts.border = '1px solid gray'

            ## Foreground color for prompts.
            c.colors.prompts.fg = '${toRGB theme.fg}'

            ## Background color for the selected item in filename prompts.
            # c.colors.prompts.selected.bg = 'grey'

            ## Background color of the statusbar in caret mode.
            # c.colors.statusbar.caret.bg = 'purple'

            ## Foreground color of the statusbar in caret mode.
            c.colors.statusbar.caret.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in caret mode with a selection.
            # c.colors.statusbar.caret.selection.bg = '#a12dff'

            ## Foreground color of the statusbar in caret mode with a selection.
            c.colors.statusbar.caret.selection.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in command mode.
            c.colors.statusbar.command.bg = '${toRGB theme.bg}'

            ## Foreground color of the statusbar in command mode.
            c.colors.statusbar.command.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in private browsing + command mode.
            # c.colors.statusbar.command.private.bg = 'grey'

            ## Foreground color of the statusbar in private browsing + command mode.
            c.colors.statusbar.command.private.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in insert mode.
            # c.colors.statusbar.insert.bg = 'darkgreen'

            ## Foreground color of the statusbar in insert mode.
            c.colors.statusbar.insert.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar.
            c.colors.statusbar.normal.bg = '${toRGB theme.bg}'

            ## Foreground color of the statusbar.
            c.colors.statusbar.normal.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in passthrough mode.
            # c.colors.statusbar.passthrough.bg = 'darkblue'

            ## Foreground color of the statusbar in passthrough mode.
            c.colors.statusbar.passthrough.fg = '${toRGB theme.fg}'

            ## Background color of the statusbar in private browsing mode.
            # c.colors.statusbar.private.bg = '#666666'

            ## Foreground color of the statusbar in private browsing mode.
            c.colors.statusbar.private.fg = '${toRGB theme.fg}'

            ## Background color of the progress bar.
            c.colors.statusbar.progress.bg = '${toRGB theme.fg}'

            ## Foreground color of the URL in the statusbar on error.
            # c.colors.statusbar.url.error.fg = 'orange'

            ## Default foreground color of the URL in the statusbar.
            c.colors.statusbar.url.fg = '${toRGB theme.fg}'

            ## Foreground color of the URL in the statusbar for hovered links.
            # c.colors.statusbar.url.hover.fg = 'aqua'

            ## Foreground color of the URL in the statusbar on successful load
            ## (http).
            c.colors.statusbar.url.success.http.fg = '${toRGB theme.fg}'

            ## Foreground color of the URL in the statusbar on successful load
            ## (https).
            # c.colors.statusbar.url.success.https.fg = 'lime'

            ## Foreground color of the URL in the statusbar when there's a warning.
            # c.colors.statusbar.url.warn.fg = 'yellow'

            ## Background color of the tab bar.
            c.colors.tabs.bar.bg = '${toRGB theme.bg}'

            ## Background color of unselected even tabs.
            c.colors.tabs.even.bg = '${toRGB theme.bg}'

            ## Foreground color of unselected even tabs.
            c.colors.tabs.even.fg = '${toRGB theme.fg}'

            ## Color for the tab indicator on errors.
            c.colors.tabs.indicator.error = '${toRGB theme.error}'

            ## Color gradient start for the tab indicator.
            # c.colors.tabs.indicator.start = '#0000aa'

            ## Color gradient end for the tab indicator.
            # c.colors.tabs.indicator.stop = '#00aa00'

            ## Background color of unselected odd tabs.
            c.colors.tabs.odd.bg = '${toRGB theme.bg}'

            ## Foreground color of unselected odd tabs.
            c.colors.tabs.odd.fg = '${toRGB theme.fg}'

            ## Background color of pinned unselected even tabs.
            # c.colors.tabs.pinned.even.bg = 'darkseagreen'

            ## Foreground color of pinned unselected even tabs.
            c.colors.tabs.pinned.even.fg = '${toRGB theme.fg}'

            ## Background color of pinned unselected odd tabs.
            # c.colors.tabs.pinned.odd.bg = 'seagreen'

            ## Foreground color of pinned unselected odd tabs.
            c.colors.tabs.pinned.odd.fg = '${toRGB theme.fg}'

            ## Background color of pinned selected even tabs.
            c.colors.tabs.pinned.selected.even.bg = '${toRGB theme.bg-alt}'

            ## Foreground color of pinned selected even tabs.
            c.colors.tabs.pinned.selected.even.fg = '${toRGB theme.fg}'

            ## Background color of pinned selected odd tabs.
            c.colors.tabs.pinned.selected.odd.bg = '${toRGB theme.bg-alt}'

            ## Foreground color of pinned selected odd tabs.
            c.colors.tabs.pinned.selected.odd.fg = '${toRGB theme.fg}'

            ## Background color of selected even tabs.
            c.colors.tabs.selected.even.bg = '${toRGB theme.bg-alt}'

            ## Foreground color of selected even tabs.
            c.colors.tabs.selected.even.fg = '${toRGB theme.fg}'

            ## Background color of selected odd tabs.
            c.colors.tabs.selected.odd.bg = '${toRGB theme.bg-alt}'

            ## Foreground color of selected odd tabs.
            c.colors.tabs.selected.odd.fg = '${toRGB theme.fg}'

            ## Background color for webpages if unset (or empty to use the theme's
            ## color).
            c.colors.webpage.bg = 'white'
            c.fonts.tabs = 'Share Tech'
            c.hints.border = '1px solid ${toRGB theme.accent}'
          '';
        };
      };
      variables = {
        BROWSER = "google-chrome-unstable";
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
          chrome = (pkgs.google-chrome-dev.override {
            commandLineArgs = "--disk-cache-dir=/tmp/.chrome-$USER";
          });
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
            qutebrowser
            (chrome)
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
