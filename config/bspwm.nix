{ config, pkgs, ... }:

{
  services.xserver.windowManager = {
    bspwm = {
      enable = true;
      configFile = "/etc/bspwmrc";
      sxhkd.configFile = "/etc/sxhkdrc";
    };
    default = "bspwm";
  };
  environment.etc.sxhkdrc = {
    text = ''
# rofi applications menu
super + space
  rofi -show combi -normal-window
# terminal
super + Return
  termsel
# browser
super + slash
  exec $BROWSER &
# calculator
super + equal
  galculator
# filemanager
super + backslash
  termite -e ranger

# switch, move window
super + {_,shift + }{Left,Down,Up,Right}
  bspc node -{f,s} {west,south,north,east}
# focus or move window to desktop
super + {_,shift + }{1-9,0}
  bspc {desktop -f,node -d} '^{1-9,10}'
# move next/prev ws
super + bracket{left,right}
  bspc desktop -f {prev,next}.local
# close window
super + q
  bspc node -c
# logout, shutdown
super + {shift,ctrl} + q
  mate-session-save --{logout,shutdown}-dialog
# rotate 180
super + h
  bspc node @/ --rotate 180

# monocle toggle
super + m
  bspc desktop -l next
# tile/pseudo-tile toggle
super + {_,shift + }t
  bspc node -t {_,pseudo_}tiled
# floating/fullscreen toggle
super + {_,shift + }f
  bspc node -t {floating,fullscreen}

# screen/window/selection shot
super + {_,shift +,ctrl +} + @Print
  scrot {_,-u,-s} -e "notify-send -i image 'scrot' 'image saved as \n\$f'"

# clipboard select
super + Insert
  clipmenu
# clear clipboard history
super + shift + Insert
  clipdel -d '.*'

# reload keybindings
super + shift + r
  ~/.local/bin/reload

# music controls
XF86AudioRaiseVolume
  pactl set-sink-volume 0 '+10%'

XF86AudioLowerVolume
  pactl set-sink-volume 0 '-10%'

XF86AudioMute
  pactl set-sink-mute 0 toggle

XF86AudioPrev
  playerctl previous

XF86AudioNext
  playerctl next

XF86AudioPlay
  playerctl play-pause

XF86AudioStop
  playerctl stop
    '';
  };
  environment.etc.bspwmrc = {
    text = ''
bspc config border_width         3 
bspc config window_gap           0
bspc config split_ratio          0.50 
bspc config borderless_monocle   true 
bspc config gapless_monocle      true
bspc config single_monocle       true
bspc config focus_follows_pointer false
    '';
  };
}
