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
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.lightdm.background =
      nixpkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
    home-manager.users.${config.wellKnown.username} = { lib, ... }: {
      dconf.settings = with lib.hm.gvariant; {
        "org/gnome/desktop/a11y" = {
          always-show-universal-access-status = true;
        };
        "org/gnome/desktop/a11y/applications" = {
          screen-magnifier-enabled = false;
        };
        "org/gnome/desktop/a11y/magnifier" = {
          lens-mode = true;
          mag-factor = 2.0;
          mouse-tracking = "proportional";
          screen-position = "full-screen";
          scroll-at-edges = false;
        };
        "org/gnome/desktop/input-sources" = {
          current = mkUint32 0;
          per-window = false;
          sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) ];
          xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" ];
        };
        "org/gnome/desktop/interface" = {
          cursor-size = 48;
          gtk-im-module = "ibus";
          gtk-theme = "HighContrast";
          icon-theme = "HighContrast";
          show-battery-percentage = true;
          text-scaling-factor = 1.5;
        };
        "org/gnome/desktop/peripherals/mouse" = {
          natural-scroll = false;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
          two-finger-scrolling-enabled = true;
        };
        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 0;
        };
        "org/gnome/desktop/sound" = {
          allow-volume-above-100-percent = true;
        };
        "org/gnome/desktop/wm/preferences" = {
          theme = "HighContrast";
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = false;
          night-light-schedule-automatic = false;
          night-light-schedule-from = 12.0;
          night-light-schedule-to = 11.99;
          night-light-temperature = mkUint32 3700; # 1700 (warm) to 4700 (cold)
        };
        "org/gnome/settings-daemon/plugins/power" = {
          idle-dim = false;
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
      };
    };
    services.xserver.enable = true;
    services.xserver.layout = "us";
    services.xserver.libinput.enable = true;
    services.xserver.updateDbusEnvironment = true;
    services.xserver.xkbVariant = "altgr-intl";
    time.timeZone = config.ui.timezone;
    ui.font = "ProFont for Powerline";
  };
}
