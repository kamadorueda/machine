_: with _; {
  xserver = {
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
    libinput = {
      enable = true;
    };
  };
}
