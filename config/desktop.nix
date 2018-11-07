{ config, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./mate.nix
    ./polybar.nix
  ];
  environment.systemPackages = with pkgs; [
    sxhkd rofi-unwrapped libnotify feh clipmenu
    chromium
    networkmanagerapplet
    xdg-desktop-portal-gtk xorg.xkill
    numix-solarized-gtk-theme capitaine-cursors
    (rxvt_unicode.override {
      unicode3Support = true;
      perlSupport = false;
    })
  ];
  systemd.services.clipmenud = {
     serviceConfig.Type = "simple";
     wantedBy = [ "graphical.target" ];
     path = [ pkgs.clipmenu ];
     script = ''
       clipmenud
     '';
  }; 
  environment.variables = {
    TERMINAL = "urxvt";
    BROWSER = "chromium";
  };
  environment.etc."ld-nix.so.preload" = if config.virtualisation.virtualbox.guest.enable then {
    text = ''
      ${pkgs.linuxPackages.virtualboxGuestAdditions}/lib/VBoxOGL.so
    '';
  } else {
    text = "";
  };

  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
  };
  networking.networkmanager = {
    enable = true;
  };
  fonts.fonts = with pkgs; [
    font-awesome_5
    google-fonts
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
#define S_base03        #002b36
#define S_base02        #073642
#define S_base01        #586e75
#define S_base00        #657b83
#define S_base0         #839496
#define S_base1         #93a1a1
#define S_base2         #eee8d5
#define S_base3         #fdf6e3
#define S_yellow        #b58900
#define S_orange        #cb4b16
#define S_red           #dc322f
#define S_magenta       #d33682
#define S_violet        #6c71c4
#define S_blue          #268bd2
#define S_cyan          #2aa198
#define S_green         #859900

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
rofi.color-normal: S_base3,S_base00,S_base3,S_base2,S_base00
rofi.color-urgent: S_base3,S_red,S_base3,S_base3,S_red
rofi.color-active: S_base3,S_base01,S_base3,S_base2,S_base01
rofi.color-window: S_base3,S_base3,S_base3
rofi.display-drun: 
rofi.display-run: 
rofi.display-window: 
rofi.display-ssh: 
rofi.display-combi: 
rofi.combi-modi: window,run,drun
rofi.monitor: -1

URxvt*scrollBar:         false
URxvt*scrollBar_right:   false
URxvt*transparent:       false
URxvt.font: xft:Fira Mono Medium:pixelsize=20
URxvt.boldFont:
URxvt.letterSpace: 0
URxvt.internalBorder: 16

*background:            S_base3
*foreground:            S_base00
*fading:                40
*fadeColor:             S_base3
*cursorColor:           S_base01
*pointerColorBackground:S_base1
*pointerColorForeground:S_base01

!! black dark/light
*color0:                S_base02
*color8:                S_base03

!! red dark/light
*color1:                S_red
*color9:                S_orange

!! green dark/light
*color2:                S_green
*color10:               S_base01

!! yellow dark/light
*color3:                S_yellow
*color11:               S_base00

!! blue dark/light
*color4:                S_blue
*color12:               S_base0

!! magenta dark/light
*color5:                S_magenta
*color13:               S_violet

!! cyan dark/light
*color6:                S_cyan
*color14:               S_base1

!! white dark/light
*color7:                S_base2
*color15:               S_base3
    '';
  };
  services.compton = {
    enable = true;
    shadow = true;
    shadowOffsets = [ (-9) (-3) ];
    shadowExclude = [
	    "name = 'Polybar tray window'"
    	"_GTK_FRAME_EXTENTS@:c"
    ];
    shadowOpacity = "0.5";
    extraOptions = ''
      shadow-radius = 6;
    '';
  };
}
