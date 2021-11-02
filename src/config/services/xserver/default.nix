_: with _; {
  desktopManager = {
    gnome = {
      enable = true;
    };
  };
  displayManager = {
    lightdm = {
      background = packages.nixpkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath;
    };
  };
  enable = true;
  layout = "us";
  libinput = {
    enable = true;
  };
  updateDbusEnvironment = true;
  xkbVariant = "altgr-intl";
}
