{ config
, lib
, nixpkgs
, ...
}:

{

  options = {
    ui.font = lib.mkOption {
      type = lib.types.str;
    };
    ui.locale = lib.mkOption {
      type = lib.types.str;
    };
    ui.timezone = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    fonts.enableDefaultFonts = true;
    fonts.fonts = [ nixpkgs.powerline-fonts ];
    i18n.defaultLocale = config.ui.locale;
    programs.dconf.enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = config.wellKnown.username;
    services.xserver.displayManager.defaultSession = "none+i3";
    services.xserver.enable = true;
    services.xserver.layout = "us";
    services.xserver.windowManager.i3.configFile =
      builtins.toFile "i3.conf" ''
        # i3 config file (v4)
        #
        # Please see https://i3wm.org/docs/userguide.html for a complete reference!

        set $mod Mod4

        font pango:${config.ui.font} 16

        # Use pactl to adjust volume in PulseAudio.
        set $refresh_i3status killall -SIGUSR1 i3status
        bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
        bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
        bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
        bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

        # Use Mouse+$mod to drag floating windows to their wanted position
        floating_modifier $mod

        # start a terminal
        bindsym $mod+Return exec xterm

        # kill focused window
        bindsym $mod+Shift+q kill

        # start dmenu (a program launcher)
        bindsym $mod+d exec --no-startup-id dmenu_run

        # change focus
        bindsym $mod+Left focus left
        bindsym $mod+Down focus down
        bindsym $mod+Up focus up
        bindsym $mod+Right focus right

        # move focused window
        bindsym $mod+Shift+Left move left
        bindsym $mod+Shift+Down move down
        bindsym $mod+Shift+Up move up
        bindsym $mod+Shift+Right move right

        # split in horizontal orientation
        bindsym $mod+h split h

        # split in vertical orientation
        bindsym $mod+v split v

        # enter fullscreen mode for the focused container
        bindsym $mod+f fullscreen toggle

        # change container layout (stacked, tabbed, toggle split)
        bindsym $mod+s layout stacking
        bindsym $mod+w layout tabbed
        bindsym $mod+e layout toggle split

        # toggle tiling / floating
        bindsym $mod+Shift+space floating toggle

        # change focus between tiling / floating windows
        bindsym $mod+space focus mode_toggle

        # Define names for default workspaces for which we configure key bindings later on.
        # We use variables to avoid repeating the names in multiple places.
        set $ws1 "1"
        set $ws2 "2"
        set $ws3 "3"
        set $ws4 "4"
        set $ws5 "5"
        set $ws6 "6"
        set $ws7 "7"
        set $ws8 "8"
        set $ws9 "9"
        set $ws10 "10"

        # switch to workspace
        bindsym $mod+1 workspace number $ws1
        bindsym $mod+2 workspace number $ws2
        bindsym $mod+3 workspace number $ws3
        bindsym $mod+4 workspace number $ws4
        bindsym $mod+5 workspace number $ws5
        bindsym $mod+6 workspace number $ws6
        bindsym $mod+7 workspace number $ws7
        bindsym $mod+8 workspace number $ws8
        bindsym $mod+9 workspace number $ws9
        bindsym $mod+0 workspace number $ws10

        # move focused container to workspace
        bindsym $mod+Shift+1 move container to workspace number $ws1
        bindsym $mod+Shift+2 move container to workspace number $ws2
        bindsym $mod+Shift+3 move container to workspace number $ws3
        bindsym $mod+Shift+4 move container to workspace number $ws4
        bindsym $mod+Shift+5 move container to workspace number $ws5
        bindsym $mod+Shift+6 move container to workspace number $ws6
        bindsym $mod+Shift+7 move container to workspace number $ws7
        bindsym $mod+Shift+8 move container to workspace number $ws8
        bindsym $mod+Shift+9 move container to workspace number $ws9
        bindsym $mod+Shift+0 move container to workspace number $ws10

        # reload the configuration file
        bindsym $mod+Shift+c reload
        # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        bindsym $mod+Shift+r restart
        # exit i3 (logs you out of your X session)
        bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

        # resize window (you can also use the mouse for that)
        mode "resize" {
          # These bindings trigger as soon as you enter the resize mode

          bindsym Left resize shrink width 10 px or 10 ppt
          bindsym Down resize grow height 10 px or 10 ppt
          bindsym Up resize shrink height 10 px or 10 ppt
          bindsym Right resize grow width 10 px or 10 ppt

          # back to normal: Enter or Escape or $mod+r
          bindsym $mod+r mode "default"
        }

        bindsym $mod+r mode "resize"

        # Start i3bar to display a workspace bar (plus the system information i3status
        # finds out, if available)
        bar {
          status_command i3status -c ${./i3status.conf}
        }
      '';
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.extraPackages = [
      nixpkgs.dmenu
      nixpkgs.i3status
    ];
    services.xserver.xkbVariant = "altgr-intl";
    time.timeZone = config.ui.timezone;
    ui.font = "ProFont for Powerline";
  };
}
