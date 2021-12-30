{ config
, ...
}:

let
  inherit (config.wellKnown) hashedPassword;
  inherit (config.wellKnown) username;
  inherit (config.wellKnown.paths) home;
in
{
  users.mutableUsers = false;
  users.users.root = {
    inherit hashedPassword;
  };
  users.users.${username} = {
    extraGroups = [ "networkmanager" "wheel" ];
    inherit hashedPassword;
    inherit home;
    isNormalUser = true;
  };
}
