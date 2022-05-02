{config, ...}: {
  environment.etc."NetworkManager/system-connections/airuc-secure.nmconnection" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/machine/airuc-secure.nmconnection";
  };
  environment.etc."NetworkManager/system-connections/eduroam.nmconnection" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/machine/eduroam.nmconnection";
  };
  environment.etc."NetworkManager/system-connections/SPSETUP-2C38.nmconnection" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/machine/spsetup-2c38.nmconnection";
  };
  networking.networkmanager.enable = true;
  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];
}
