# starlight-os
NixOS based Linux operating system for software development

WARNING!!! The partition script in this repository could ERASE ALL OF YOUR DATA!!!

principles:
  be vi-like
  be minimal
  for development (code and audio)
  do syntax-highlighting and auto-completion
  everywhere.

 key-bindings:
 	super + arrow:
 		change focus
 	super + number:
 		change desktop
  super + [:
    previous desktop
  super + ]:
    next desktop
  super + shift + arrow:
    move window
  super + shift + number:
    move window to desktop
  super + shift + [:
    move window to previous desktop
  super + shift + ]:
    move window to next desktop

  super + space:
    menu
  super + enter:
    terminal

  super + q:
     quit
  super + shift + q:
     logout...
  super + control + q:
    shutdown...

  super + page-up/page-down:
    rotate 90 deg
  super + shift + backspace:
    reload bar and key-bindings

  super + f:
    float window
  super + shift + f:
    full-screen window
  super + t:
    tile window
  super + a:
    anchor window (pseudo-tile)
  super + m:
    monocle mode toggle

