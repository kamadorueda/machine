{config, ...}: {
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [];
  networking.firewall.allowedTCPPorts = [];

  networking.hostName = "machine";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  networking.networkmanager.enable = true;

  sops.secrets."wifi/24f42fdc30" = {
    mode = "400";
    path = "/etc/NetworkManager/system-connections/24f42fdc30";
    restartUnits = ["NetworkManager.service"];
  };
  sops.secrets."wifi/wifi-5394" = {
    mode = "400";
    path = "/etc/NetworkManager/system-connections/wifi-5394";
    restartUnits = ["NetworkManager.service"];
  };

  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];
}
