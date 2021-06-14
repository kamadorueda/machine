_: with _; {
  mutableUsers = false;
  users = {
    root = {
      password = "1";
    };
    "${abs.username}" = {
      extraGroups = [ "wheel" ];
      home = abs.home;
      isNormalUser = true;
      password = "1";
    };
  };
}
