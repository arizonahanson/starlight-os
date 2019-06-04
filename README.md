# starlight-os
NixOS based Linux operating system for software development

WARNING!!! The partition script in this repository could ERASE ALL OF YOUR DATA!!!

principles:
 * tiled operation - like vim, tmux
 * minimal clicks & keystrokes
 * heavy tmux, zsh, fzf, vim & git integration
 * atomic upgrades/rollback
 * optimized for virtualbox & hardware
 * no post-configuration warranted
 * pro-audio support
 * TODO: tablet support

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

