{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnome3.dconf ];
  environment.etc.dconf_keyfile = {
    target = "dconf/db/site.d/system.txt";
    text = ''
[org/mate/power-manager]
button-power='interactive'
info-last-device='/org/freedesktop/UPower/devices/battery_BAT0'
button-lid-ac='nothing'
action-low-ups='interactive'
action-critical-battery='shutdown'
button-suspend='nothing'
info-page-number=0
info-history-type='charge'
button-lid-battery='nothing'
info-stats-type='discharge-accuracy'
action-sleep-type-ac='interactive'
icon-policy='charge'
idle-dim-ac=false
sleep-display-ac=0
sleep-display-battery=0

[org/mate/settings-daemon/plugins/xrdb]
active=false

[org/mate/settings-daemon/plugins/a11y-keyboard]
active=false

[org/mate/settings-daemon/plugins/xrandr]
turn-on-external-monitors-at-startup=true
active=false

[org/mate/settings-daemon/plugins/typing-break]
active=false

[org/mate/settings-daemon/plugins/smartcard]
active=false

[org/mate/desktop/interface]
menus-have-icons=true
gtk-decoration-layout='menu:close'
cursor-blink-time=1000
monospace-font-name='Input 11'
gtk-im-module='ibus'
accessibility=true

[org/mate/desktop/applications/browser]
exec='chromium'

[org/mate/desktop/media-handling]
automount-open=false
autorun-never=true

[org/mate/desktop/session]
auto-save-session=false
idle-delay=10
required-components-list=@as []

[org/mate/desktop/session/required-components]
windowmanager='bspwm'
panel='''
filemanager='''

[org/mate/desktop/peripherals/keyboard]
numlock-state='on'

[org/mate/desktop/sound]
input-feedback-sounds=true
event-sounds=true
theme-name='freedesktop'

[org/mate/desktop/background]
draw-background=false
show-desktop-icons=false
background-fade=false

[apps/seahorse]
server-auto-retrieve=false
server-auto-publish=false

[ca/desrt/dconf-editor]
show-warning=false
window-is-maximized=false

[org/mate/settings-daemon/plugins/background]
active=false

[org/mate/settings-daemon/plugins/housekeeping]
active=false

[org/mate/settings-daemon/plugins/media-keys]
active=false

[org/mate/settings-daemon/plugins/keybindings]
active=false

[org/mate/settings-daemon/plugins/keyboard]
active=false

[org/mate/settings-daemon/plugins/datetime]
active=false

[org/mate/settings-daemon/plugins/clipboard]
active=false

[org/mate/settings-daemon/plugins/mouse]

[org/gnome/desktop/wm/keybindings]
switch-input-source=['<Super>k']
switch-input-source-backward=['<Shift><Super>k']

[org/gtk/settings/file-chooser]
date-format='regular'
location-mode='path-bar'
show-hidden=false
show-size-column=true
sort-column='name'
sort-directories-first=false
sort-order='ascending'

[org/mate/desktop/peripherals/mouse]
double-click=600

[org/gnome/desktop/a11y/mouse]
click-type-window-geometry='''
click-type-window-orientation='vertical'
click-type-window-style='both'
click-type-window-visible=true
dwell-click-enabled=false
secondary-click-time=1.0

[org/mate/desktop/accessibility/keyboard]
mousekeys-enable=true
enable=true
bouncekeys-beep-reject=true
bouncekeys-delay=300
bouncekeys-enable=false
feature-state-change-beep=false
mousekeys-accel-time=300
mousekeys-init-delay=300
mousekeys-max-speed=10
slowkeys-beep-accept=true
slowkeys-beep-press=true
slowkeys-beep-reject=false
slowkeys-delay=300
slowkeys-enable=false
stickykeys-enable=false
stickykeys-modifier-beep=true
stickykeys-two-key-off=true
timeout=120
timeout-enable=false
togglekeys-enable=false
      
[org/mate/terminal/profiles/default]
background-color='#000000000000'
bold-color='#000000000000'
foreground-color='#FFFFFFFFFFFF'
palette='#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC'
visible-name='Default'
allow-bold=false
default-show-menubar=false
font='Monospace 14'
login-shell=true
scroll-on-output=true
scrollbar-position='hidden'
use-system-font=false
use-theme-colors=false

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
  services.dbus.packages = [ pkgs.gnome3.dconf ];
}
