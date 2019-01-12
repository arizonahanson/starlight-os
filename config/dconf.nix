{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnome3.dconf ];
  environment.etc.dconf_keyfile = {
    target = "dconf/db/site.d/keyfile";
    text = ''
      [org/gnome/desktop/a11y/mouse]
      click-type-window-style='both'
      secondary-click-time=1.0
      click-type-window-geometry='''
      dwell-click-enabled=false
      click-type-window-orientation='vertical'
      click-type-window-visible=true

      [org/mate/notification-daemon]
      popup-location='top_right'
      theme='slider'

      [org/mate/settings-daemon/plugins/keyboard]
      active=false

      [org/mate/settings-daemon/plugins/keybindings]
      active=false

      [org/mate/settings-daemon/plugins/media-keys]
      active=false

      [org/mate/settings-daemon/plugins/xrdb]
      active=false

      [org/mate/settings-daemon/plugins/a11y-keyboard]
      active=false

      [org/mate/settings-daemon/plugins/xrandr]
      active=false
      turn-on-external-monitors-at-startup=true

      [org/mate/settings-daemon/plugins/typing-break]
      active=false

      [org/mate/settings-daemon/plugins/smartcard]
      active=false

      [org/mate/settings-daemon/plugins/datetime]
      active=false

      [org/mate/settings-daemon/plugins/housekeeping]
      active=false

      [org/mate/settings-daemon/plugins/background]
      active=false

      [org/mate/settings-daemon/plugins/clipboard]
      active=false

      [org/mate/power-manager]
      button-power='interactive'
      sleep-display-battery=0
      button-lid-ac='nothing'
      action-low-ups='interactive'
      action-critical-battery='shutdown'
      button-suspend='nothing'
      info-page-number=0
      idle-dim-ac=false
      info-history-type='charge'
      button-lid-battery='nothing'
      info-stats-type='discharge-accuracy'
      action-sleep-type-ac='interactive'
      icon-policy='charge'
      sleep-display-ac=0

      [org/mate/desktop/interface]
      menus-have-icons=true
      gtk-decoration-layout='menu:close'
      font-name='Exo 2 14'
      gtk-im-module='ibus'
      cursor-blink-time=1000
      monospace-font-name='Fira Mono 11'
      accessibility=true
      gtk-theme='starlight'
      icon-theme='starlight'

      [org/mate/desktop/applications/browser]
      exec='chromium'

      [org/mate/desktop/media-handling]
      automount-open=false
      autorun-never=true
      
      [org/mate/desktop/peripherals/keyboard]
      numlock-state='on'

      [org/mate/desktop/peripherals/mouse]
      double-click=600
      cursor-theme='capitaine-cursors'

      [org/mate/desktop/session]
      auto-save-session=false
      idle-delay=10
      required-components-list=['windowmanager', 'filemanager']


      [org/mate/desktop/session/required-components]
      windowmanager='bspwm'
      panel='''
      filemanager='caja'

      [org/mate/desktop/sound]
      input-feedback-sounds=true
      theme-name='freedesktop'
      event-sounds=true

      [org/mate/desktop/accessibility/keyboard]
      slowkeys-beep-press=true
      mousekeys-accel-time=300
      bouncekeys-beep-reject=true
      slowkeys-beep-reject=false
      togglekeys-enable=false
      enable=true
      bouncekeys-enable=false
      stickykeys-enable=false
      feature-state-change-beep=false
      slowkeys-beep-accept=true
      bouncekeys-delay=300
      mousekeys-max-speed=10
      mousekeys-enable=true
      timeout-enable=false
      slowkeys-delay=300
      stickykeys-modifier-beep=true
      stickykeys-two-key-off=true
      mousekeys-init-delay=300
      timeout=120
      slowkeys-enable=false

      [org/mate/desktop/background]
      draw-background=false
      show-desktop-icons=false
      background-fade=false

      [org/mate/desktop/font-rendering]
      antialiasing='rgba'
      hinting='slight'

      [apps/seahorse]
      server-auto-retrieve=false
      server-auto-publish=false

      [desktop/ibus/general/hotkey]
      triggers=['<Super>K']

      [desktop/ibus/panel/emoji]
      partial-match-condition=2
      has-partial-match=true
      lang='en'
      font='Noto Emoji 18'
      hotkey=['<Control><Shift>e']

      [desktop/ibus/panel]
      show=0
      show-icon-on-systray=true
      xkb-icon-rgba='#787878'

      [org/mate/marco/general]
      theme='starlight'
    '';
  };
      
  environment.etc.dconf_profile = {
    target = "dconf/profile/user";
    text = ''
      service-db:keyfile/user
      system-db:site
    '';
  };
  programs.dconf = {
    enable = true;
  };
  systemd.services.dconf-update = { 
     serviceConfig.Type = "oneshot"; 
     wantedBy = [ "multi-user.target" ]; 
     path = [ pkgs.gnome3.dconf ]; 
     script = '' 
       dconf update 
     ''; 
  }; 
  services.dbus.packages = [ pkgs.gnome3.dconf ];
}
