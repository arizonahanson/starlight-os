{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ polybar ];
    etc."polybar.conf" = {
      mode = "0644";
      text = ''
        [colors]
        background = ''${xrdb:color0}
        background-alt = ''${xrdb:color8}
        foreground = ''${xrdb:color15}
        foreground-alt = ''${xrdb:color7}
        red = ''${xrdb:color1}
        orange = ''${xrdb:color9}
        green = ''${xrdb:color2}
        yellow = ''${xrdb:color11}
        blue = ''${xrdb:color4}
        purple = ''${xrdb:color5}
        cyan = ''${xrdb:color6}
        accent = ''${colors.blue}
        alert = ''${colors.red}

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

        line-size = 3
        line-color = ''${colors.accent}

        border-size = 1
        border-color = ''${colors.background-alt}

        padding-left = 4
        padding-right = 1

        module-margin-left = 1
        module-margin-right = 1

        font-0 = Exo 2:style=Bold:size=12;2
        font-1 = Exo 2:style=Bold:size=14;3
        font-2 = Font Awesome 5 Free Solid:size=14;4
        font-3 = Noto Emoji:size=14;4
        font-4 = DejaVu Sans:size=14;2

        modules-left = xwindow
        modules-center =
        modules-right = temperature cal bspwm

        tray-position = center
        tray-padding = 2
        tray-maxsize = 24

        wm-restack = bspwm
        override-redirect = false

        scroll-up = bspwm-desknext
        scroll-down = bspwm-deskprev

        cursor-click = default
        cursor-scroll = default

        [module/onboard]
        type = custom/script
        exec-if = test -x /usr/bin/onboard
        exec = echo 
        click-left = onboard &
        interval = 3600
        format-foreground = ''${colors.foreground-alt}

        [module/cal]
        type = custom/script
        exec = date '+%a %l:%M %p' | sed 's/  / /'
        interval = 30
        format-foreground = ''${colors.foreground-alt}
        label-font = 1

        [module/xwindow]
        type = internal/xwindow
        label = %title:0:64:…%
        label-font = 2
        label-empty = •
        label-empty-font = 4
        label-empty-foreground = ''${colors.foreground}

        [module/bspwm]
        type = internal/bspwm

        format = <label-mode><label-state>
        format-foreground = ''${colors.foreground}

        label-focused = "▣ "
        label-focused-foreground = ''${colors.foreground}
        label-focused-padding = 0

        label-occupied = "▨ "
        label-occupied-padding = 0
        label-occupied-foreground = ''${colors.foreground-alt}

        label-urgent = "▩ "
        label-urgent-foreground = ''${colors.alert}
        label-urgent-padding = 0

        label-empty = "▢ "
        label-empty-foreground = ''${colors.background-alt}
        label-empty-padding = 0

        label-focused-font = 5
        label-occupied-font = 5
        label-urgent-font = 5
        label-empty-font = 5

        label-dimmed-focused-foreground = ''${colors.foreground-alt}

        label-monocle = "  "
        label-floating = "  "
        label-pseudotiled = "  "

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
        label-warn-foreground = ''${colors.orange}
        label-warn-font = 1

        ramp-0 = 
        ramp-1 = 
        ramp-2 = 
        ramp-foreground = ''${colors.orange}

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
}
