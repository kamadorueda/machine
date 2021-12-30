{ config
, ...
}:

let
  inherit (config.wellKnown) username;
in
{
  users.mutableUsers = false;
  users.users.root = {
    hashedPassword = config.wellKnown.hashedPassword;
  };
  users.users.${username} = {
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = config.wellKnown.hashedPassword;
    home = config.wellKnown.paths.home;
    isNormalUser = true;
  };
}
