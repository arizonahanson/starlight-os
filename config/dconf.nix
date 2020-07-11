{ config, lib, pkgs, ... }:

with lib;

{
  config = let
    cfg = config.starlight;
    toRGB = num: elemAt (attrValues cfg.palette) num;
    dconf-keyfile = pkgs.writeTextFile {
      name = "dconf-keyfile";
      destination = "/etc/dconf/db/user.d/keyfile";
      text = ''
        [org/gnome/desktop/a11y/mouse]
        click-type-window-style='both'
        secondary-click-time=1.0
        click-type-window-geometry='''
        dwell-click-enabled=false
        click-type-window-orientation='vertical'
        click-type-window-visible=true

        [org/mate/notification-daemon]
        popup-location='top_right'
        theme='slider'

        [org/mate/settings-daemon/plugins/keyboard]
        active=false

        [org/mate/settings-daemon/plugins/keybindings]
        active=false

        [org/mate/settings-daemon/plugins/media-keys]
        active=false

        [org/mate/settings-daemon/plugins/xrdb]
        active=false

        [org/mate/settings-daemon/plugins/a11y-keyboard]
        active=false

        [org/mate/settings-daemon/plugins/xrandr]
        active=false
        turn-on-external-monitors-at-startup=true

        [org/mate/settings-daemon/plugins/typing-break]
        active=false

        [org/mate/settings-daemon/plugins/smartcard]
        active=false

        [org/mate/settings-daemon/plugins/datetime]
        active=false

        [org/mate/settings-daemon/plugins/housekeeping]
        active=false

        [org/mate/settings-daemon/plugins/background]
        active=false

        [org/mate/settings-daemon/plugins/clipboard]
        active=false

        [org/mate/power-manager]
        button-power='interactive'
        sleep-display-battery=0
        button-lid-ac='nothing'
        action-low-ups='interactive'
        action-critical-battery='shutdown'
        button-suspend='nothing'
        info-page-number=0
        idle-dim-ac=false
        info-history-type='charge'
        button-lid-battery='nothing'
        info-stats-type='discharge-accuracy'
        action-sleep-type-ac='interactive'
        icon-policy='charge'
        sleep-display-ac=0

        [org/mate/desktop/interface]
        menus-have-icons=true
        gtk-decoration-layout='menu:close'
        font-name='${cfg.fonts.uiFont} 16'
        gtk-im-module='ibus'
        cursor-blink-time=1000
        monospace-font-name='${cfg.fonts.monoFont} 16'
        accessibility=true
        gtk-theme='Starlight'
        icon-theme='Starlight'

        [org/mate/desktop/applications/browser]
        exec='google-chrome-stable'

        [org/mate/desktop/media-handling]
        automount-open=false
        autorun-never=true

        [org/mate/desktop/peripherals/keyboard]
        remember-numlock-state=false
        numlock-state='on'

        [org/mate/desktop/peripherals/mouse]
        double-click=600
        cursor-theme='Bibata_Oil'
        cursor-size=${toString cfg.pointerSize}

        [org/mate/desktop/session]
        auto-save-session=false
        idle-delay=10
        required-components-list=['filemanager']

        [org/mate/desktop/session/required-components]
        filemanager='caja'

        [org/mate/desktop/sound]
        input-feedback-sounds=true
        theme-name='freedesktop'
        event-sounds=true

        [org/mate/desktop/accessibility/keyboard]
        slowkeys-beep-press=true
        mousekeys-accel-time=300
        bouncekeys-beep-reject=true
        slowkeys-beep-reject=false
        togglekeys-enable=false
        enable=true
        bouncekeys-enable=false
        stickykeys-enable=false
        feature-state-change-beep=false
        slowkeys-beep-accept=true
        bouncekeys-delay=300
        mousekeys-max-speed=10
        mousekeys-enable=true
        timeout-enable=false
        slowkeys-delay=300
        stickykeys-modifier-beep=true
        stickykeys-two-key-off=true
        mousekeys-init-delay=300
        timeout=120
        slowkeys-enable=false

        [org/mate/desktop/background]
        draw-background=false
        show-desktop-icons=false
        background-fade=false

        [org/mate/desktop/font-rendering]
        antialiasing='rgba'
        hinting='slight'

        [apps/seahorse]
        server-auto-retrieve=false
        server-auto-publish=false

        [desktop/ibus/general/hotkey]
        triggers=['<Super>K']

        [desktop/ibus/panel/emoji]
        partial-match-condition=2
        has-partial-match=true
        lang='en'
        font='Noto Emoji 16'
        hotkey=['<Control><Shift>e']

        [desktop/ibus/panel]
        show=0
        show-icon-on-systray=true
        xkb-icon-rgba='${toRGB cfg.theme.fg}'

        [org/mate/marco/general]
        theme='Starlight'
      ''
      + optionalString config.starlight.touchscreen.enable ''
        [org/gnome/desktop/a11y/applications]
        screen-keyboard-enabled=true

        [org/onboard]
        schema-version='2.3'
        system-theme-associations={'HighContrast': 'HighContrast', 'HighContrastInverse': 'HighContrastInverse', 'LowContrast': 'LowContrast', 'ContrastHighInverse': 'HighContrastInverse', 'Default': ''', 'starlight': '/etc/onboard/starlight.theme'}
        use-system-defaults=false
        start-minimized=false
        status-icon-provider='GtkStatusIcon'
        snippets=@as []

        [org/onboard/theme-settings]
        color-scheme='/etc/onboard/starlight.colors'
        key-fill-gradient=5.0
        key-size=94.0
        key-stroke-width=50.0
        key-style='gradient'
        roundrect-radius=12.0
        key-gradient-direction=0.0
        key-stroke-gradient=0.0
        key-label-font='${cfg.fonts.uiFont} bold'
        key-label-overrides=['LWIN:${removeSuffix " " cfg.logo}:super', 'RWIN:${removeSuffix " " cfg.logo}:super']
        key-shadow-size=50.0
        key-shadow-strength=50.0

        [org/onboard/icon-palette]
        in-use=true
        window-handles='M'

        [org/onboard/icon-palette/landscape]
        x=64
        y=64

        [org/gnome/desktop/interface]
        toolkit-accessibility=true

        [org/onboard/auto-show]
        enabled=true

        [org/onboard/window]
        docking-aspect-change-range=[0.0, 100.0]
        inactive-transparency-delay=5.0
        transparent-background=true
        enable-inactive-transparency=true
        docking-shrink-workarea=false

        [org/onboard/keyboard]
        default-key-action='single-stroke'
        touch-feedback-enabled=true

        [org/onboard/typing-assistance/word-suggestions]
        enabled=true
        wordlist-buttons=['previous-predictions', 'next-predictions', 'pause-learning', 'hide']
      '';
    };
    dconf-profile = pkgs.writeTextFile {
      name = "dconf-profile";
      destination = "/etc/dconf/profile/user";
      text = ''
        service-db:keyfile/user
        system-db:local
      '';
    };
  in
      lib.mkIf config.starlight.desktop {
      programs.dconf = {
        enable = true;
        packages = [ dconf-keyfile dconf-profile ];
      };
    };
}
