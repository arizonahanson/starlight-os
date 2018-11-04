{ config, pkgs, ... }:

{
  services.xserver.windowManager.bspwm = {
    enable = true;
    configFile = "/etc/bspwmrc";
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
