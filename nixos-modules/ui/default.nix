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
    ui.fontSize = lib.mkOption {
      apply = builtins.toString;
      type = lib.types.ints.positive;
    };
    ui.timezone = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    fonts.enableDefaultFonts = true;
    fonts.fonts = [ nixpkgs.powerline-fonts ];
    i18n.defaultLocale = "en_US.UTF-8";
    programs.dconf.enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = config.wellKnown.username;
    services.xserver.displayManager.defaultSession = "none+i3";
    services.xserver.enable = true;
    services.xserver.layout = "us";
    services.xserver.windowManager.i3.configFile = builtins.toFile "i3.conf" ''
      font pango:${config.ui.font} ${config.ui.fontSize}

      bar {
        status_command i3status -c ${./i3status.conf}
      }

      include ${./i3.conf}
    '';
    services.xserver.windowManager.i3.enable = true;
    services.xserver.windowManager.i3.extraPackages = [
      nixpkgs.dmenu
      nixpkgs.i3status
    ];
    services.xserver.xkbVariant = "altgr-intl";
    time.timeZone = config.ui.timezone;
    ui.font = "ProFont for Powerline";
    ui.fontSize = 22;
  };
}
