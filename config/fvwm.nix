{ config, lib, pkgs, ... }:

with lib;

{
  config = lib.mkIf config.starlight.desktop {
    services.xserver.windowManager = {
      fvwm2 = {
        enable = true;
      };
    };
    environment.etc.fvwm2rc =
      let
        cfg = config.starlight;
        toRGB = num: elemAt (attrValues cfg.palette) num;
      in
      {
        mode = "0645";
        text = ''
          ##################################
          #  ____________________________
          # (   _________________________)
          #  ) (__  _  _  _    _
          # (   __)( \/ )( \/\/ )/\/\
          #  ) (    \  /  \    //    \
          # (___)    \/    \/\/(_/\/\_) 2.6
          #
          #
          #  This config file is organized as follows:
          #
          #    1: Functions
          #    2: Styles
          #    3: Colorsets
          #    4: Menus
          #    5: Bindings
          #    6: Decor
          #    7: Modules
          #
          #################################

          # InfoStoreAdd can be used to store variable data internal to fvwm.
          # The variable can then be used in the configuration as $[infostore.name].
          #
          # You can also use environment variables but for data internal to fvwm
          # use InfoStore variables instead.
          #
          # The following is used in various menus and also sets the terminal
          # that FvwmConsole uses. Change this to your terminal of choice
          InfoStoreAdd terminal terminal

          ###########
          # 1: Functions
          #
          # Fvwm can use custom functions for various tasks.
          # The syntax for defining a function named FunctionName is:
          #
          #   DestroyFunc FunctionName
          #   AddToFunc FunctionName
          #   + I [Action to do Immediately]
          #   + C [Action to do on a Mouse Click]
          #   + D [Action to do on a Mouse Double Click]
          #   + H [Action to do on a Mouse Hold]
          #   + M [Action to do on a Mouse Motion]
          ###########

          # Start Function
          #
          # The start function is run right after fvwm is done reading
          # the config file. This function run after each restart
          # so using Test (Init) or Test (Restart) can further control
          # actions that are run during the first time run (Init) or
          # actions that are run after a restart.
          DestroyFunc StartFunction
          AddToFunc   StartFunction
          + I Test (Init) \
                exec feh --bg-scale /etc/nixos/wallpaper.jpg
          #+ I Test (Init) Module FvwmBanner
          #+ I Module FvwmButtons RightPanel
          #+ I Module FvwmEvent EventNewDesk

          # Mouse Bindings Functions
          DestroyFunc RaiseMoveX
          AddToFunc RaiseMoveX
          + I Raise
          + M $0
          + D $1

          DestroyFunc RaiseMove
          AddToFunc RaiseMove
          + I Raise
          + M $0

          DestroyFunc MoveToCurrent
          AddToFunc MoveToCurrent
          + I ThisWindow MoveToPage
          + I ThisWindow MoveToDesk

          # Function: ViewManPage $0
          #
          # This function loads the man page $0 in an terminal
          # and is used with the help menu.
          DestroyFunc ViewManPage
          AddToFunc   ViewManPage
          + I Exec exec $[infostore.terminal] -g 80x40 \
            -n "Manual Page - $0" -T "Manual Page - $0" -e man "$0"

          # Function: SetBG $0
          #
          # SetBG is used with the background menu to set the background
          # image and configure it to be loaded the next time fvwm is run.
          # Note, fvwm-root can't use .jpeg or resize images. Use something
          # like display, feh, etc.
          DestroyFunc SetBG
          AddToFunc   SetBG
          + I Test (f $[FVWM_USERDIR]/images/background/$0) \
              Exec exec fvwm-root $[FVWM_USERDIR]/images/background/$0
          + I TestRc (Match) Exec exec ln -fs images/background/$0 \
              $[FVWM_USERDIR]/.BGdefault
          + I TestRc (Match) Break
          + I Test (!f $[FVWM_DATADIR]/default-config/images/background/$0) Break
          + I Exec exec fvwm-root $[FVWM_DATADIR]/default-config/images/background/$0
          + I Exec exec ln -fs $[FVWM_DATADIR]/default-config/images/background/$0 \
              $[FVWM_USERDIR]/.BGdefault


          # Function: IconManClick
          #
          # This function is run from FvwmIconMan when the button is clicked.
          DestroyFunc IconManClick
          AddToFunc   IconManClick
          + I ThisWindow (Raised, !Shaded, !Iconic, CurrentPage) Iconify
          + I TestRc (Match) Break
          + I ThisWindow WindowShade off
          + I ThisWindow Iconify off
          + I ThisWindow Raise
          + I ThisWindow (AcceptsFocus) FlipFocus

          # Function: ToggleTitle
          #
          # This function will toggle if fvwm shows the TitleBar.
          DestroyFunc ToggleTitle
          AddToFunc   ToggleTitle
          + I ThisWindow (State 1) WindowStyle Title
          + I TestRc (Match) State 1 False
          + I TestRc (Match) Break
          + I WindowStyle !Title
          + I State 1 True

          # Function: ChangeDesk
          #
          # This function is called by FvwmEvent every time the Desk is changed.
          DestroyFunc ChangeDesk
          AddToFunc   ChangeDesk
          + I SendToModule FvwmButtons ChangeButton desk0 Colorset 10
          + I SendToModule FvwmButtons ChangeButton desk1 Colorset 10
          + I SendToModule FvwmButtons ChangeButton desk2 Colorset 10
          + I SendToModule FvwmButtons ChangeButton desk3 Colorset 10
          + I SendToModule FvwmButtons ChangeButton desk$0 Colorset 11


          #############
          # 2: Styles #
          #############

          # Desktops and Pages
          #
          # Fvwm has both Virtual Desktops and Pages. Each Desktop is built from
          # a grid of Pages. The following sets the name of four Desktops and then
          # divides each Desktop into a 2x2 grid of Pages that are positioned as
          #
          #   +---+---+
          #   |   |   |
          #   +---+---+
          #   |   |   |
          #   +---+---+
          #
          DesktopName 0 Main
          DesktopName 1 Desk1
          DesktopName 2 Desk2
          DesktopName 3 Desk3
          DesktopSize 2x2

          # EdgeScroll will move the view port between the Pages when the mouse
          # moves to the edge of the screen. This set the amount of distance to
          # scroll at 100% (full page) and the EdgeResistance which is a timer
          # for how long the mouse as at the edge before it scrolls.
          #
          # Set EdgeScroll 0 0 and/or EdgeResistance -1 to disable.
          EdgeScroll 100 100
          EdgeResistance 450
          EdgeThickness 1
          Style * EdgeMoveDelay 350, EdgeMoveResistance 350

          # EwmhBaseStruts [left] [right] [top] [bottom]
          # Reserves space along the edge(s) of the Screen that will not
          # be covered when maximizing or placing windows.
          EwmhBaseStruts 0 0 0 0

          # This sets the ClickTime and MoveThreshold used to determine
          # Double Clicks, Hold and Move for the mouse.
          ClickTime 250
          MoveThreshold 3

          # Sets the focus style to SloppyFocus and a mouse click
          # in a window will Raise it.
          Style * SloppyFocus, MouseFocusClickRaises

          # Default Font
          DefaultFont "xft:${cfg.fonts.uiFont}:size=12:antialias=True"

          # Window Placement
          Style * MinOverlapPlacement, GrabFocusOff, !UsePPosition

          # Sets all windows to OpaqueMove (vs a wired frame) and  windows will
          # snap to each other and the edge of the screen.
          OpaqueMoveSize unlimited
          Style * ResizeOpaque, SnapAttraction 8 SameType ScreenAll, SnapGrid

          # Transient Windows (such as open file windows)
          Style * DecorateTransient, StackTransientParent
          Style * !FPGrabFocusTransient, FPReleaseFocusTransient

          # WindowShade
          Style * WindowShadeScrolls, WindowShadeSteps 4

          # Ignore Numlock and other modifiers for bindings
          # See http://fvwm.org/documentation/faq/#why-do-numlock-capslock-and-scrolllock-interfere-with-clicktofocus-andor-my-mouse-bindings
          IgnoreModifiers L25

          # Decor Styles
          Style * BorderWidth 8, HandleWidth 8, MWMButtons, FvwmBorder, FirmBorder
          Style * Colorset 1, HilightColorset 2
          Style * BorderColorset 3, HilightBorderColorset 4

          # Disable Icons from appearing on desktop.
          # Comment this out or use Style * Icon to get the icons back.
          #Style * !Icon

          # Window Specific Styles
          Style RightPanel !Title, !Borders, !Handles, Sticky, \
                           WindowListSkip, NeverFocus
          Style ConfirmQuit !Title, PositionPlacement Center, WindowListSkip, Layer 6
          Style FvwmIdent WindowListSkip

          #######
          # 3: Colorsets
          #
          # Colorsets can be used to configure the color of the various
          # parts of fvwm such as window decor, menus, modules, etc.
          #
          # Colorset Convention
          #
          #   0 - Default
          #   1 - Inactive Windows
          #   2 - Active Window
          #   3 - Inactive Windows Borders
          #   4 - Active Windows Borders
          #   5 - Menu - Inactive Item
          #   6 - Menu - Active Item
          #   7 - Menu - Grayed Item
          #   8 - Menu - Title
          #   9 - Reserved
          #  10+ Modules
          #      10 - Module Default
          #      11 - Module Hilight
          #      12 - Module ActiveButton (Mouse Hover)
          #      13 - FvwmPager Active Page
          #      14 - FvwmIconMan Iconified Button
          ###########
          Colorset 0   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 1   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 2   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 3   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.bg-alt}, sh ${toRGB cfg.theme.bg}, Plain, NoShape
          Colorset 4   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg-alt}, hi ${cfg.palette.cursor}, sh ${toRGB cfg.theme.bg}, Plain, NoShape
          Colorset 5   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 6   fg ${toRGB cfg.theme.bg}, bg ${toRGB cfg.theme.fg}, hi ${toRGB cfg.theme.bg-alt}, sh ${toRGB cfg.theme.fg-alt}, Plain, NoShape
          Colorset 7   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 8   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 9   fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 10  fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 11  fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 12  fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 13  fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape
          Colorset 14  fg ${toRGB cfg.theme.fg}, bg ${toRGB cfg.theme.bg}, hi ${toRGB cfg.theme.fg-alt}, sh ${toRGB cfg.theme.bg-alt}, Plain, NoShape

          #######
          # 4: Menus
          ###########
          MenuStyle * MenuColorset 5, ActiveColorset 6, GreyedColorset 7, TitleColorset 8
          MenuStyle * Hilight3DOff, HilightBack, HilightTitleBack, SeparatorsLong
          MenuStyle * TrianglesSolid, TrianglesUseFore
          MenuStyle * ItemFormat "%|%3.1i%5.3l%5.3>%|"
          MenuStyle * Font "xft:${cfg.fonts.uiFont}:size=12:antialias=True"

          # Root Menu
          #
          # The root menu will PopUp with a click in the root
          # window or using alt-f1 (or menu).
          DestroyMenu MenuFvwmRoot
          AddToMenu   MenuFvwmRoot "Fvwm" Title
          + "&Programs%icons/programs.png%" Popup MenuPrograms
          + "XDG &Menu%icons/apps.png%" Popup XDGMenu
          + "&XTerm%icons/terminal.png%" Exec exec $[infostore.terminal]
          + "" Nop
          + "Fvwm&Console%icons/terminal.png%" Module FvwmConsole -terminal $[infostore.terminal]
          + "&Wallpapers%icons/wallpaper.png%" Popup BGMenu
          + "M&an Pages%icons/help.png%" Popup MenuFvwmManPages
          + "Copy Config%icons/conf.png%" FvwmScript FvwmScript-ConfirmCopyConfig
          + "" Nop
          + "Re&fresh%icons/refresh.png%" Refresh
          + "&Restart%icons/restart.png%" Restart
          + "&Quit%icons/quit.png%" Module FvwmScript FvwmScript-ConfirmQuit

          # Generate XDGMenu
          PipeRead "fvwm-menu-desktop -e"

          # Programs Menu
          #
          # This test for some common programs and adds them to the menu.
          # When adding programs you don't need to use the Test (x foo)
          # lines as this is only to help make this menu portable.
          DestroyMenu MenuPrograms
          AddToMenu   MenuPrograms "Programs" Title
          Test (x chromium) + "Chromium" Exec exec chromium
          Test (x firefox) + "Firefox" Exec exec firefox
          Test (x google-chrome) + "Google-Chrome" Exec exec google-chrome
          Test (x gvim) + "gVim" Exec exec gvim
          Test (x xemacs) + "XEmacs" Exec exec xemacs
          Test (x gimp) + "Gimp" Exec exec gimp
          Test (x vlc) + "VLC" Exec exec vlc

          # Background Menu
          #
          # Backgrounds are located in ~/.fvwm/images/background/
          # Menu icons are located in ~/.fvwm/images/bgicons/
          DestroyMenu BGMenu
          AddToMenu   BGMenu "Wallpapers" Title
          + "Floral%bgicons/bg1.png%" SetBG bg1.png
          + "Circles%bgicons/bg2.png%" SetBG bg2.png
          + "Space%bgicons/bg3.png%" SetBG bg3.png

          # Window Operations Menus
          DestroyMenu MenuWindowOps
          AddToMenu   MenuWindowOps
          + "Move"      Move
          + "Resize"    Resize
          + "Iconify"   Iconify
          + "Maximize"  Maximize
          + "Shade"     WindowShade
          + "Stick"     Stick
          + "" Nop
          + "Close"     Close
          + "More..."   Menu MenuWindowOpsLong This 0 0

          DestroyMenu MenuWindowOpsLong
          AddToMenu   MenuWindowOpsLong
          + "Move"                Move
          + "Resize"              Resize
          + "(De)Iconify"         Iconify
          + "(Un)Maximize"        Maximize
          + "(Un)Shade"           WindowShade
          + "(Un)Sticky"    Stick
          + "(No)TitleBar"  Pick (CirculateHit) ToggleTitle
          + "Send To"             Popup MenuSendTo
          + "" Nop
          + "Close"               Close
          + "Destroy"             Destroy
          + "" Nop
          + "Raise"    Raise
          + "Lower"    Lower
          + "" Nop
          + "StaysOnTop"          Pick (CirculateHit) Layer 0 6
          + "StaysPut"            Pick (CirculateHit) Layer 0 4
          + "StaysOnBottom"       Pick (CirculateHit) Layer 0 2
          + "" Nop
          + "Identify"            Module FvwmIdent

          DestroyMenu MenuIconOps
          AddToMenu   MenuIconOps
          + "(De)Iconify"         Iconify
          + "(Un)Maximize"        Maximize
          + "(Un)Shade"           WindowShade
          + "(Un)Sticky"    Stick
          + "(No)TitleBar"  Pick (CirculateHit) ToggleTitle
          + "Send To"             Popup MenuSendTo
          + "" Nop
          + "Close"               Close
          + "Destroy"             Destroy
          + "" Nop
          + "Raise"    Raise
          + "Lower"    Lower
          + "" Nop
          + "StaysOnTop"          Pick (CirculateHit) Layer 0 6
          + "StaysPut"            Pick (CirculateHit) Layer 0 4
          + "StaysOnBottom"       Pick (CirculateHit) Layer 0 2
          + "" Nop
          + "Identify"            Module FvwmIdent

          DestroyMenu MenuSendTo
          AddToMenu MenuSendTo
          + "Current" MoveToCurrent
          + "Page" PopUp MenuSendToPage
          + "Desk" PopUp MenuSendToDesk

          DestroyMenu MenuSendToDesk
          AddToMenu   MenuSendToDesk
          + "Desk 0"  MoveToDesk 0 0
          + "Desk 1"  MoveToDesk 0 1
          + "Desk 2"  MoveToDesk 0 2
          + "Desk 3"  MoveToDesk 0 3

          DestroyMenu MenuSendToPage
          AddToMenu   MenuSendToPage
          + "Page (0,0)"  MoveToPage 0 0
          + "Page (0,1)"  MoveToPage 0 1
          + "Page (1,0)"  MoveToPage 1 0
          + "Page (1,1)"  MoveToPage 1 1


          # Fvwm Man Pages (Help) Menu
          DestroyMenu MenuFvwmManPages
          AddToMenu   MenuFvwmManPages "Help" Title
          + "fvwm"                ViewManPage fvwm
          + "FvwmAnimate"         ViewManPage FvwmAnimate
          + "FvwmAuto"            ViewManPage FvwmAuto
          + "FvwmBacker"          ViewManPage FvwmBacker
          + "FvwmBanner"          ViewManPage FvwmBanner
          + "FvwmButtons"         ViewManPage FvwmButtons
          + "FvwmCommand"         ViewManPage FvwmCommand
          + "FvwmConsole"         ViewManPage FvwmConsole
          + "FvwmEvent"           ViewManPage FvwmEvent
          + "FvwmForm"            ViewManPage FvwmForm
          + "FvwmIconMan"         ViewManPage FvwmIconMan
          + "FvwmIdent"           ViewManPage FvwmIdent
          + "FvwmPager"           ViewManPage FvwmPager
          + "FvwmPerl"            ViewManPage FvwmPerl
          + "FvwmProxy"           ViewManPage FvwmProxy
          + "FvwmRearrange"       ViewManPage FvwmRearrange
          + "FvwmScript"          ViewManPage FvwmScript
          + "" Nop
          + "fvwm-root"          ViewManPage fvwm-root
          + "fvwm-menu-desktop"   ViewManPage fvwm-menu-desktop
          + "fvwm-menu-directory" ViewManPage fvwm-menu-directory
          + "fvwm-menu-headlines" ViewManPage fvwm-menu-headlines
          + "fvwm-menu-xlock"     ViewManPage fvwm-menu-xlock
          + "fvwm-config"         ViewManPage fvwm-config

          #######
          # 5: Mouse and Key bindings
          #
          # Contexts:
          #     R = Root Window                 rrrrrrrrrrrrrrrrrrrrrr
          #     W = Application Window          rIrrrr<---------^rrrrr
          #     F = Frame Corners               rrrrrr[13TTTT642]rrrrr
          #     S = Frame Sides                 rIrrrr[wwwwwwwww]rrrrr
          #     T = Title Bar                   rrrrrr[wwwwwwwww]rrrrr
          #     I = Icon                        rIrrrrv_________>rrrrr
          #                                     rrrrrrrrrrrrrrrrrrrrrr
          #
          #     Numbers are buttons: [1 3 5 7 9  TTTTT  0 8 6 4 2]
          #
          # Modifiers: (A)ny, (C)ontrol, (S)hift, (M)eta, (N)othing
          #
          # Format: Key <X>  <Context> <Modifier> <Action>
          #         Mouse <X> <Context> <Modifier> <Action>
          ####################

          # Alt-F1 or Menu to load the root menu and Alt-Tab for a WindowList.
          # Ctrl-F1/F2/F3/F4 will switch between the Virtual Desktops.
          # Super_R (windows key) will launch a terminal.
          #
          # Silent supresses any errors (such as keyboards with no Menu key).
          Silent Key F1 A M Menu MenuFvwmRoot
          Silent Key Menu A A Menu MenuFvwmRoot
          Silent Key Tab A M WindowList Root c c NoDeskSort, SelectOnRelease Meta_L
          Silent Key F1 A C GotoDesk 0 0
          Silent Key F2 A C GotoDesk 0 1
          Silent Key F3 A C GotoDesk 0 2
          Silent Key F4 A C GotoDesk 0 3
          Silent Key Super_R A A Exec exec $[infostore.terminal]

          # Window Buttons: [1 3 5 7 9  TTTTT  0 8 6 4 2]
          #   1 - Open the WindowOps menu.
          #   2 - Close on single click, Destory on double click.
          #   4 - Maximize (right/middle button will only maximize vertical/horizontal)
          #   6 - Iconify (minimize)
          Mouse 1 1 A Menu MenuWindowOps Delete
          Mouse 1 2 A Close
          Mouse 1 4 A Maximize 100 100
          Mouse 2 4 A Maximize 0 100
          Mouse 3 4 A Maximize 100 0
          Mouse 1 6 A Iconify

          #   TitleBar: Click to Raise, Move, Double Click to Maximize
          #             Mouse Wheel Up/Down to WindowShade On/Off
          #   Borders: Click to raise, Move to Resize
          #   Root Window: Left Click - Main Menu
          #                Right Click - WindowOps Menu
          #                Middle Click - Window List Menu
          #   Right click TitleBar/Borders for WindowOps Menu
          Mouse 1  T    A RaiseMoveX Move Maximize
          Mouse 1  FS   A RaiseMove Resize
          Mouse 4  T    A WindowShade True
          Mouse 5  T    A WindowShade False
          Mouse 1  R    A Menu MenuFvwmRoot
          Mouse 2  R    A WindowList
          Mouse 3  R    A Menu MenuWindowOpsLong
          Mouse 1  I    A RaiseMoveX Move "Iconify off"
          Mouse 3  T    A Menu MenuWindowOps
          Mouse 3 I    A Menu MenuIconOps

          #######
          # 6: Window Decor
          #
          # Buttons Locations: [1 3 5 7 9  TTTTT  0 8 6 4 2]
          #
          #   1 - WindowOps Menu
          #   2 - Close
          #   4 - Maximize
          #   6 - Minimize
          ###########
          TitleStyle Centered Height 32 -- Flat
          ButtonStyle All ActiveUp Vector 5 15x15@4 15x85@3 85x85@3 85x15@3 \
                          15x15@3 -- Flat
          ButtonStyle All ToggledActiveUp Vector 5 15x15@4 15x85@3 85x85@3 \
                          85x15@3 15x15@3 -- Flat
          ButtonStyle All ActiveDown Vector 5 20x20@4 20x80@3 80x80@3 80x20@3 \
                          20x20@3 -- Flat
          ButtonStyle All ToggledActiveDown Vector 5 20x20@4 20x80@3 80x80@3 \
                          80x20@3 20x20@3 -- Flat
          ButtonStyle All ToggledInactive Vector 5 47x47@3 57x53@3 53x53@3 \
                          53x47@3 47x47@3 -- Flat
          ButtonStyle All Inactive Vector 5 47x47@3 57x53@3 53x53@3 53x47@3 \
                          47x47@3 -- Flat
          AddButtonStyle 1 Active Vector 5 45x45@3 55x45@3 55x55@3 45x55@3 45x45@3
          AddButtonStyle 2 Active Vector 4 35x35@3 65x65@3 65x35@4 35x65@3
          AddButtonStyle 4 Active Vector 8 30x70@3 30x30@3 70x30@3 70x70@3 30x70@3 \
                           30x50@4 50x50@3 50x70@3
          AddButtonStyle 4 ToggledActiveUp Vector 8 30x70@3 30x30@3 70x30@3 70x70@3 \
                           30x70@3 50x30@4 50x50@3 70x50@3
          AddButtonStyle 6 Active Vector 5 35x60@3 65x60@3 65x50@3 35x50@3 35x60@3
          ButtonStyle All - Clear
          ButtonStyle 1 - MwmDecorMenu
          ButtonStyle 4 - MwmDecorMax
          ButtonStyle 6 - MwmDecorMin

          ############
          # 7: Modules
          #############

          # FvwmIdent
          #
          # FvwmIdent is a module that can be used to get the various info about
          # a window. One use is getting the class/resource/name of a window.
          DestroyModuleConfig FvwmIdent:*
          *FvwmIdent: Colorset 10
          *FvwmIdent: Font "xft:Sans:size=10:antialias=True"

          # FvwmBanner
          #
          # This displays the Fvwm Logo for 5 seconds. This is displayed
          # when fvwm starts.
          DestroyModuleConfig FvwmBanner:*
          *FvwmBanner: NoDecor
          *FvwmBanner: Timeout 5

          # FvwmScript
          #
          # FvwmScript is a module that allows one to write custom desktop
          # widgets and various other tools. This config uses two FvwmScripts.
          #   - DateTime - uses the output of "date" to display the date/time
          #     on the RightPanel.
          #   - Quit - This is a popup that asks for quit confirmation before
          #     quitting fvwm.
          DestroyModuleConfig FvwmScript:*
          *FvwmScript: DefaultColorset 10

          # FvwmButtons - RightPanel
          #
          # FvwmButtons is a powerful module that can be used to build custom
          # panels and docks. This config uses FvwmButtons to build the RightPanel.
          # The panel contains buttons to switch desks, FvwmPager, a system tray,
          # FvwmIconMan (list of running windows), and a clock.
          #
          # Note - To use the system tray you must have "stalonetray" installed.
          DestroyModuleConfig RightPanel:*
          *RightPanel: Geometry 120x$[vp.height]-0+0
          *RightPanel: Colorset 10
          *RightPanel: Rows $[vp.height]
          *RightPanel: Columns 120
          *RightPanel: Frame 0
          *RightPanel: Font "xft:Sans:Bold:size=10:antialias=True"
          *RightPanel: (120x45, Icon "fvwm-logo-small.png", Frame 0)
          *RightPanel: (120x5, Frame 0)
          *RightPanel: (10x20, Frame 0)
          *RightPanel: (25x20, Id desk0, Title "0", Action (Mouse 1) GotoDesk 0 0, Colorset 11, ActiveColorset 12, Frame 0)
          *RightPanel: (25x20, Id desk1, Title "1", Action (Mouse 1) GotoDesk 0 1, ActiveColorset 12, Frame 0)
          *RightPanel: (25x20, Id desk2, Title "2", Action (Mouse 1) GotoDesk 0 2, ActiveColorset 12, Frame 0)
          *RightPanel: (25x20, Id desk3, Title "3", Action (Mouse 1) GotoDesk 0 3, ActiveColorset 12, Frame 0)
          *RightPanel: (10x20, Frame 0)
          *RightPanel: (5x80, Frame 0)
          *RightPanel: (110x80, Swallow FvwmPager 'Module FvwmPager *', Frame 0)
          *RightPanel: (5x80, Frame 0)
          *RightPanel: (120x5, Frame 0)
          Test (x stalonetray) *RightPanel: (120x20, Swallow(NoClose,UseOld) \
              stalonetray 'Exec exec stalonetray --config \
              "$[FVWM_DATADIR]/default-config/.stalonetrayrc"', Frame 0)
          Test (x stalonetray) PipeRead 'echo "*RightPanel: (120x$(($[vp.height]-225)), \
              Top, Swallow FvwmIconMan \'Module FvwmIconMan\', Frame 0)"'
          Test (!x stalonetray) PipeRead 'echo "*RightPanel: (120x$(($[vp.height]-205)),\
              Top, Swallow FvwmIconMan \'Module FvwmIconMan\', Frame 0)"'
          *RightPanel: (120x45, Swallow DateTime 'Module FvwmScript FvwmScript-DateTime',\
              Frame 0)
          *RightPanel: (120x5, Frame 0)

          # FvwmPager
          #
          # This module displays the location of the windows on the various Pages
          # and Desks. This is setup to show only the Pages on the current Desk.
          DestroyModuleConfig FvwmPager:*
          *FvwmPager: Colorset * 10
          *FvwmPager: HilightColorset * 13
          *FvwmPager: BalloonColorset * 10
          *FvwmPager: WindowColorsets 10 11
          *FvwmPager: Font None
          *FvwmPager: Balloons All
          *FvwmPager: BalloonFont "xft:Sans:Bold:size=8:antialias=True"
          *FvwmPager: BallonYOffset +2
          *FvwmPager: Window3dBorders
          *FvwmPager: MiniIcons

          # FvwmIconMan
          #
          # FvwmIconMan is a powerful tool to list and manage windows. This
          # is used as the window list in the panel or taskbar.
          DestroyModuleConfig FvwmIconMan:*
          *FvwmIconMan: UseWinList true
          *FvwmIconMan: ButtonGeometry 120x20
          *FvwmIconMan: ManagerGeometry 1x1
          *FvwmIconMan: Background #003c3c
          *FvwmIconMan: Foreground #ffffff
          *FvwmIconMan: FocusColorset 11
          *FvwmIconMan: IconColorset 14
          *FvwmIconMan: FocusAndSelectColorset 12
          *FvwmIconMan: SelectColorset 12
          *FvwmIconMan: IconAndSelectColorset 12
          *FvwmIconMan: DrawIcons always
          *FvwmIconMan: ReliefThickness 0
          *FvwmIconMan: Format "%t"
          *FvwmIconMan: Font "xft:Sans:Bold:size=8:antialias=True"
          *FvwmIconMan: Action Mouse 0 A ret
          *FvwmIconMan: Action Mouse 1 A sendcommand IconManClick
          *FvwmIconMan: Action Mouse 3 A sendcommand "Menu MenuIconOps"
          *FvwmIconMan: Resolution global
          *FvwmIconMan: Tips needed
          *FvwmIconMan: Sort id

          # FvwmEvent
          #
          # FvwmEvent is a module that can run an action or function
          # on specific events. This instance changes which desk number
          # is highlighted when the desk is changed.
          DestroyModuleConfig EventNewDesk:*
          *EventNewDesk: PassID
          *EventNewDesk: new_desk ChangeDesk

          # FvwmForm
          #
          # FvwmForm is a module that can be used to build a GUI
          # form. Used with fvwm-menu-desktop-config.fpl.
          # This sets the default colorsets.
          *FvwmFormDefault: Colorset 10
          *FvwmFormDefault: ItemColorset 13
        '';
      };
  };
}
