{ nixpkgs
, ...
}:

{
  fonts.enableDefaultFonts = true;
  fonts.fonts = [ nixpkgs.powerline-fonts ];
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.background =
    nixpkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.updateDbusEnvironment = true;
  services.xserver.xkbVariant = "altgr-intl";
  time.timeZone = "America/Bogota";
}
