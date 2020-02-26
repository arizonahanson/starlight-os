{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    environment = {
      systemPackages = with pkgs; [ polybar ];
      etc."polybar.conf" = let
        cfg = config.starlight;
        toRGB = num: elemAt (attrValues cfg.palette) num;
      in
        {
          text = ''
            [colors]
            foreground = ${toRGB cfg.theme.fg}
            foreground-alt = ${toRGB cfg.theme.fg-alt}
            background = ${toRGB cfg.theme.bg}
            background-alt = ${toRGB cfg.theme.bg-alt}
            accent = ${toRGB cfg.theme.accent}
            info = ${toRGB cfg.theme.info}
            warn = ${toRGB cfg.theme.warning}

            [bar/default]
            monitor = ''${env:MONITOR:VGA-1}
            width = 100%
            height = 38
            offset-x = 0
            offset-y = 0
            ;radius = 8.0
            fixed-center = true
            ; Put the bar at the bottom of the screen
            ;bottom = true

            background = ''${colors.background}
            foreground = ''${colors.foreground}

            border-size = 1
            border-color = ''${colors.background-alt}

            padding-left = 3
            padding-right = 1

            module-margin-left = 0
            module-margin-right = 1

            font-0 = ${cfg.fonts.uiFont}:size=16;4
            font-1 = Font Awesome 5 Free Solid:size=14;3
            font-2 = Noto Emoji:size=14;4
            font-3 = DejaVu Sans:size=14;2
            font-4 = Font Awesome 5 Free Regular:size=14;3

            modules-left = xwindow
            modules-center =
            modules-right = temperature clock bspwm

            tray-position = center
            tray-padding = 2
            tray-maxsize = 24

            wm-restack = bspwm
            override-redirect = false

            scroll-up = bspwm-desknext
            scroll-down = bspwm-deskprev

            cursor-click = default
            cursor-scroll = default
            enable-ipc = true

            [module/onboard]
            type = custom/script
            exec-if = test -x /usr/bin/onboard
            exec = echo 
            click-left = onboard &
            interval = 3600
            format-foreground = ''${colors.foreground-alt}

            [module/clock]
            type = custom/script
            exec = date '+ %a %_d %b %l:%M %p ' | sed 's/  / /g'
            interval = 30
            format-foreground = ''${colors.foreground}
            label-font = 1

            [module/xwindow]
            type = internal/xwindow
            label = %title:0:92:…%
            label-font = 1
            label-empty = ${config.starlight.logo}
            label-empty-font = 3
            label-empty-foreground = ''${colors.foreground}

            [module/bspwm]
            type = internal/bspwm

            format = <label-mode><label-state>
            format-foreground = ''${colors.foreground}

            label-focused = " "
            label-focused-foreground = ''${colors.accent}
            label-focused-padding = 0

            label-occupied = " "
            label-occupied-padding = 0
            label-occupied-foreground = ''${colors.foreground-alt}

            label-urgent = " "
            label-urgent-foreground = ''${colors.info}
            label-urgent-padding = 0

            label-empty = " "
            label-empty-foreground = ''${colors.background-alt}
            label-empty-padding = 0

            label-focused-font = 2
            label-occupied-font = 5
            label-urgent-font = 2
            label-empty-font = 5
            label-dimmed-font = 2

            label-dimmed-focused = " "
            label-dimmed-focused-foreground = ''${colors.foreground-alt}

            label-floating = "  "
            label-pseudotiled = "  "
            label-floating-foreground = ''${colors.foreground-alt}
            label-pseudotiled-foreground = ''${colors.foreground-alt}

            [module/temperature]
            type = internal/temperature
            thermal-zone = 2
            warn-temperature = 75
            interval = 5

            format =
            format-underline =
            format-warn = <ramp> <label-warn>

            label = %temperature-c%
            label-font = 1
            label-warn = %temperature-c%
            label-warn-foreground = ''${colors.warn}
            label-warn-font = 1

            ramp-0 = 
            ramp-1 = 
            ramp-2 = 
            ramp-foreground = ''${colors.warn}

            [settings]
            screenchange-reload = true
            compositing-overline = source
            compositing-underline = source
            compositing-background = source
            compositing-foreground = source
            compositing-border = source

            [global/wm]
            margin-top = 0
            margin-bottom = 0
          '';
        };
    };
  };
}
