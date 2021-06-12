_: with _; {
  mutableUsers = false;
  users = {
    root = {
      password = "";
    };
    "${abs.username}" = {
      extraGroups = [ "wheel" ];
      home = abs.home;
      isNormalUser = true;
      password = "";
    };
  };
}
