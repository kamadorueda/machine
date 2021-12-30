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
    services.xserver.enable = true;
    services.xserver.layout = "us";
    services.xserver.libinput.enable = true;
    services.xserver.updateDbusEnvironment = true;
    services.xserver.xkbVariant = "altgr-intl";
    time.timeZone = config.ui.timezone;
    ui.font = "ProFont for Powerline";
  };
}
