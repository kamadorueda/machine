_: with _; {
  desktopManager = {
    gnome = {
      enable = true;
    };
  };
  displayManager = {
    gdm = {
      enable = true;
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
      enable = true;
      extraPackages = [
        packages.nixpkgs.i3status
      ];
      extraSessionCommands = ''
        echo Hello from i3
      '';
    };
  };
  xkbVariant = "altgr-intl";
}
