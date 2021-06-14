_: with _; {
  dbus = {
    enable = true;
  };
  xserver = {
    desktopManager = {
      gnome = {
        enable = true;
        extraGSettingsOverrides = ''
        '';
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
    xkbVariant = "altgr-intl";
  };
}
