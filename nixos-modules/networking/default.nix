{ config
, ...
}:
{
  environment.etc."NetworkManager/system-connections/home24.nmconnection" = { enable = true; mode = "0400"; source = ./home24.nmconnection; };
  environment.etc."NetworkManager/system-connections/home50.nmconnection" = { enable = true; mode = "0400"; source = ./home50.nmconnection; };
  networking.networkmanager.enable = true;
  users.users.${ config.wellKnown.username }.extraGroups = [ "networkmanager" ];
}
