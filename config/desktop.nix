{ config, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./mate.nix
    ./polybar.nix
    ./theme.nix
  ];
  environment.systemPackages = with pkgs; [
    sxhkd rofi-unwrapped libnotify feh clipmenu
    chromium playerctl
    networkmanagerapplet
    xdg-desktop-portal-gtk xorg.xkill xdo xsel
    (termite.override {
      configFile = "/etc/termite.conf";
    })
    (with import <nixpkgs> {}; writeShellScriptBin "cliprofi" ''
      ${rofi-unwrapped}/bin/rofi -p  -dmenu -normal-window $@
    '')
    (with import <nixpkgs> {}; writeShellScriptBin "reload-desktop" ''
      pkill -USR1 -x sxhkd
      pkill -USR1 -x polybar
      ${libnotify}/bin/notify-send -i keyboard 'Reloaded desktop' 'desktop bar and key-bindings reloaded'
    '')
    (with import <nixpkgs> {}; writeShellScriptBin "terminal" ''
      CLASS_NAME="terminal"
      SESSION_NAME=""
      # does term with CLASS_NAME exist?
      if xdo id -N "$CLASS_NAME">/dev/null; then
        # focus, move to current desktop the existing term with CLASS_NAME
        for NODE_ID in $(xdo id -N ''${CLASS_NAME}); do
          bspc node $NODE_ID -d focused -m focused
          bspc node -f $NODE_ID
        done
      else
        # create new term with CLASS_NAME
        # create new tmux session, or attach if exists
        termite -e "tmux-session ''${SESSION_NAME}" --class="''${CLASS_NAME}"
      fi
    '')
  ];
  systemd.user.services.clipmenud = {
     serviceConfig.Type = "simple";
     wantedBy = [ "default.target" ];
     environment = {
       DISPLAY = ":0";
     };
     path = [ pkgs.clipmenu ];
     script = ''
       ${pkgs.clipmenu}/bin/clipmenud
     '';
  };
  environment.variables = {
    TERMINAL = "termite";
    BROWSER = "chromium";
    CM_LAUNCHER = "cliprofi";
    SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
  };
  environment.etc."termite.conf" = {
    mode = "0644";
    text = ''
[options]
font = Fira Mono Medium 14
allow_bold = false

[colors]

# special
foreground      = #969696
foreground_bold = #969696
cursor          = #969696
background      = #363636

# black
color0  = #363636
color8  = #424242

# red
color1  = #dc322f
color9  = #cb4b16

# green
color2  = #859900
color10 = #859900

# yellow
color3  = #b58900
color11 = #b58900

# blue
color4  = #268bd2
color12 = #268bd2

# magenta
color5  = #d33682
color13 = #6c71c4

# cyan
color6  = #2aa198
color14 = #2aa198

# white
color7  = #eeeeee
color15 = #fdfdfd
    '';
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
  fonts.fontconfig = {
      localConf = ''
<fontconfig>
  <match target="pattern">
    <edit name="family" mode="prepend_first">
      <string>Font Awesome 5 Free Solid</string>
    </edit>
  </match>
  <match target="pattern">
    <edit name="family" mode="prepend_first">
      <string>Noto Emoji</string>
    </edit>
  </match>
</fontconfig>
    '';
    useEmbeddedBitmaps = true;
  };
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
  };
  programs.chromium = {
    enable = true;
    extraOpts = {
      DiskCacheDir = "/tmp/.chromium-\${user_name}";
    };
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
rofi.width:             28
rofi.lines:             5
rofi.columns:           1
! "border width"
rofi.bw:                2
rofi.location:          1
rofi.padding:           12
rofi.yoffset:           44
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
rofi.color-normal: #363636,#969696,#363636,#424242,#969696
rofi.color-urgent: #363636,#dc322f,#363636,#424242,#dc322f
rofi.color-active: #363636,#eeeeee,#363636,#424242,#eeeeee
rofi.color-window: #363636,#363636,#363636
rofi.display-drun: 
rofi.display-run: 
rofi.display-window: 
rofi.display-ssh: 
rofi.display-combi: 
rofi.combi-modi: window,run,drun
rofi.monitor: -1
! special
*.foreground:   #969696
*.background:   #363636
*.cursorColor:  #969696

! black
*.color0:       #363636
*.color8:       #424242

! red
*.color1:       #dc322f
*.color9:       #cb4b16

! green
*.color2:       #859900
*.color10:      #859900

! yellow
*.color3:       #b58900
*.color11:      #b58900

! blue
*.color4:       #268bd2
*.color12:      #268bd2

! magenta
*.color5:       #d33682
*.color13:      #6c71c4

! cyan
*.color6:       #2aa198
*.color14:      #2aa198

! white
*.color7:       #eeeeee
*.color15:      #fdfdfd
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
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;
  boot.plymouth = {
    enable = true;
  };
}
