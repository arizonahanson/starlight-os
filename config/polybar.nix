{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ polybar ];
    etc."polybar.conf" = {
      mode = "0644";
      text = ''
[colors]
background = ''${xrdb:background}
background-alt = ''${xrdb:color7}
foreground = ''${xrdb:foreground}
foreground-alt = ''${xrdb:color10}
base02 = ''${xrdb:color0}
base03 = ''${xrdb:color8}
red = ''${xrdb:color1}
orange = ''${xrdb:color9}
green = ''${xrdb:color2}
base01 = ''${xrdb:color10}
yellow = ''${xrdb:color3}
base00 = ''${xrdb:color11}
blue = ''${xrdb:color4}
base0 = ''${xrdb:color12}
magenta = ''${xrdb:color5}
violet = ''${xrdb:color13}
cyan = ''${xrdb:color6}
base1 = ''${xrdb:color14}
base2 = ''${xrdb:color7}
base3 = ''${xrdb:color15}
        
accent = ''${colors.blue}        
alert = ''${colors.red}

[bar/default]
monitor = ''${env:MONITOR:VGA-1}
width = 100%
height = 44
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

border-size = 2
border-color = ''${colors.background-alt}

padding-left = 2
padding-right = 0

module-margin-left = 1
module-margin-right = 1

font-0 = Font Awesome 5 Free Solid:size=17;5
font-1 = Font Awesome 5 Brands:size=17;5
font-2 = Exo 2:style=Extra Bold:size=19;4
font-3 = Exo 2:style=Bold:size=16;4
font-4 = Exo 2:style=Bold:size=14;4

modules-left = xwindow
modules-center =
modules-right = cal temperature bspwm

tray-position = center
tray-padding = 2
tray-maxsize = 24

wm-restack = bspwm
override-redirect = false

scroll-up = bspwm-desknext
scroll-down = bspwm-deskprev

cursor-click = default
cursor-scroll = ns-resize

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
format-foreground = ''${colors.base1}
label-font = 5

[module/xwindow]
type = internal/xwindow
label = %title:0:64:…%
label-foreground = ''${colors.foreground}
label-font = 4
label-empty = 
label-empty-font = 1

[module/bspwm]
type = internal/bspwm

format = <label-mode><label-state>
format-foreground = ''${colors.base1}

label-focused = %name%
label-focused-foreground = ''${colors.foreground}
label-focused-underline = ''${colors.accent}
label-focused-padding = 2

label-occupied = %name%
label-occupied-padding = 2
label-occupied-foreground = ''${colors.base1}

label-urgent = %name%
label-urgent-foreground = ''${colors.alert}
label-urgent-padding = 2
label-urgent-overline = ''${colors.alert}
label-urgent-underline = ''${colors.alert}

label-empty = %name%
label-empty-foreground = ''${colors.background-alt}
label-empty-padding = 2

label-focused-font = 3
label-occupied-font = 3
label-urgent-font = 3
label-empty-font = 3

label-dimmed-focused-foreground = ''${colors.foreground}
label-dimmed-focused-underline = ''${colors.background-alt}

label-monocle = " "
label-floating = " "

[module/temperature]
type = internal/temperature
thermal-zone = 2
warn-temperature = 75

format =
format-underline =
format-warn = <ramp> <label-warn>

label = %temperature-c%
label-font = 4
label-warn = %temperature-c%
label-warn-foreground = ''${colors.orange}
label-warn-font = 4

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
