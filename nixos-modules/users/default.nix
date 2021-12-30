{ config
, ...
}:

{
  users.mutableUsers = false;
  users.users.root = {
    inherit (config.wellKnown) hashedPassword;
  };
  users.users.${config.wellKnown.username} = {
    extraGroups = [ "networkmanager" "wheel" ];
    inherit (config.wellKnown) hashedPassword;
    inherit (config.wellKnown) home;
    isNormalUser = true;
  };
}
