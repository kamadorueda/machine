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
  windowManager = {
    i3 = {
      configFile = ./i3.config;
      enable = true;
      extraPackages = [
        packages.nixpkgs.i3status
      ];
    };
  };
  xkbVariant = "altgr-intl";
}
