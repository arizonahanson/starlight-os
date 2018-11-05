{ config, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./mate.nix
    ./polybar.nix
  ];
  environment.systemPackages = with pkgs; [
    sxhkd rofi-unwrapped libnotify feh
    chromium
    networkmanagerapplet
    xdg-desktop-portal-gtk
    (rxvt_unicode.override {
      unicode3Support = true;
      perlSupport = false;
    })
  ];
  environment.variables = {
    TERMINAL = "urxvt";
    BROWSER = "chromium";
  };
  networking.networkmanager = {
    enable = true;
  };
  fonts.fonts = with pkgs; [
    font-awesome_5
    noto-fonts-emoji
  ];
  fonts.fontconfig.localConf = ''
<selectfont>
    <rejectfont>
        <pattern>
            <patelt name="family" >
                <string>Noto Color Emoji</string>
            </patelt>
        </pattern>
    </rejectfont>
</selectfont>
  '';
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
  };
  # flatpak
  services.flatpak = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  # keyring
  services.gnome3.seahorse.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  programs.zsh.interactiveShellInit = ''
    export SSH_ASKPASS="${pkgs.gnome3.seahorse}/lib/seahorse/seahorse-ssh-askpass"
  '';

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  users.users.admin.extraGroups = [ "audio" "networkmanager" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # Enable touchpad support.
    libinput.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        autoLogin = {
          enable = true;
          user = "admin";
          relogin = false;
        };
      };
    };
  };
  environment.etc."X11/Xresources" = {
    text = ''
! XFT
Xft.antialias: 1
Xft.autohint: 1
Xft.dpi: 96
Xft.hinting: 1
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
Xft.rgba: rgb

! ROFI
rofi.font:              Exo 2 SemiBold 18
rofi.modi:              window,run,drun,combi
rofi.width:             38
rofi.lines:             5
rofi.columns:           1
! "border width"
rofi.bw:                2
rofi.location:          1
rofi.padding:           12
rofi.yoffset:           52
rofi.xoffset:           4
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
rofi.color-normal: #081021,#59748f,#081021,#081021,#c7c7c7
rofi.color-urgent: #081021,#cc6666,#081021,#081021,#8fadcc
rofi.color-active: #081021,#8fadcc,#081021,#081021,#c7c7c7
rofi.color-window: #081021,#081021,#081021
rofi.display-drun: 
rofi.display-run: 
rofi.display-window: 
rofi.display-ssh: 
rofi.display-combi: 
rofi.combi-modi: window,run,drun
rofi.monitor: -1

! special
*.foreground:   #c7c7c7
*.background:   #081021
*.cursorColor:  #c7c7c7

! black
*.color0:       #212121
*.color8:       #404040

! red
*.color1:       #cc6666
*.color9:       #de985f

! green
*.color2:       #638f63
*.color10:      #85cc85

! yellow
*.color3:       #8f7542
*.color11:      #f0c674

! blue
*.color4:       #59748f
*.color12:      #8fadcc

! magenta
*.color5:       #85678f
*.color13:      #b093ba

! cyan
*.color6:       #5e8d87
*.color14:      #8abeb7

! white
*.color7:       #787878
*.color15:      #c7c7c7

URxvt*scrollBar:         false
URxvt*scrollBar_right:   false
URxvt*transparent:       false
URxvt.font: xft:DejaVu Sans Mono:pixelsize=20
URxvt.boldFont:
URxvt.letterSpace: 0
    '';
  };
  services.compton.enable = true;
}
