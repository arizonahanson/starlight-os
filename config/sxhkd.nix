{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    services.xserver.windowManager.bspwm.sxhkd.configFile = "/etc/sxhkdrc";
    environment.etc.sxhkdrc = {
      text = ''
        # rofi applications menu
        super + space
          rofi -show combi -normal-window
        # terminal
        super + Return
          terminal &

        # switch, move window
        super + {_,shift + }{Left,Down,Up,Right}
          bspc node -{f,s} {west,south,north,east}
        # focus or move window to desktop
        super + {_,shift + }{1-9,0}
          bspc {desktop -f,node -d} '^{1-9,10}'
        # move next/prev ws
        super + {_,shift + }bracket{left,right}
          bspc {desktop -f,node -d} {prev,next}.local
        # rotate (PgUp/PgDn)
        super + {Prior,Next}
          bspc node @/ --rotate {-90,90}

        # close window
        super + q
          bspc node -c
        # logout, shutdown
        super + {shift,ctrl} + q
          mate-session-save --{logout,shutdown}-dialog

        # monocle toggle
        super + ctrl  + f
          bspc desktop -l next
        # anchored/tiled toggle
        super + {_,shift + }t
          bspc node -t {_,pseudo_}tiled
        # floating/fullscreen toggle
        super + {_,shift + }f
          bspc node -t {floating,fullscreen}

        # screen/window/selection shot
        super + {_,shift +,ctrl +} + @Print
          mate-screenshot {_,-wB -e shadow,-a}

        # clipboard select
        super + Insert
          clipmenu
        # clear clipboard history
        super + shift + Insert
          clipdel -d '^.*'

        # reload keybindings
        super + shift + BackSpace
          reload-desktop &

        # music controls
        XF86AudioRaiseVolume
          ponymix increase 10

        XF86AudioLowerVolume
          ponymix decrease 10

        XF86AudioMute
          ponymix toggle

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
  };
}
