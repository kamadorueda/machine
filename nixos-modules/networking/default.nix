{
  config,
  pkgs,
  ...
}: {
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [];
  networking.firewall.allowedTCPPorts = [];

  networking.hostName = "machine";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  networking.networkmanager.enable = true;

  sops.secrets."cloudflared-tunnel" = {
    restartUnits = ["docker-cloudflared-tunnel.service"];
  };
  sops.secrets."wifi/24f42fdc30" = {
    mode = "400";
    path = "/etc/NetworkManager/system-connections/24f42fdc30";
    restartUnits = ["NetworkManager.service"];
  };
  sops.secrets."wifi/spsetup-2c38" = {
    mode = "400";
    path = "/etc/NetworkManager/system-connections/spsetup-2c38";
    restartUnits = ["NetworkManager.service"];
  };

  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];

  virtualisation.oci-containers.containers.cloudflared-tunnel = {
    image = "cloudflare/cloudflared:latest";
    cmd = ["tunnel" "--no-autoupdate" "run"];
    extraOptions = ["--network" "host"];
    environmentFiles = [config.sops.secrets."cloudflared-tunnel".path];
  };
}
