{config, ...}: {
  environment.etc."NetworkManager/system-connections/wifi-airuc-secure" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/wifi-airuc-secure";
  };
  environment.etc."NetworkManager/system-connections/wifi-eduroam" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/wifi-eduroam";
  };
  environment.etc."NetworkManager/system-connections/wifi-SPSETUP-2C38" = {
    enable = true;
    mode = "0400";
    source = "${config.secrets.path}/wifi-spsetup-2c38";
  };
  networking.networkmanager.enable = true;
  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];
}
