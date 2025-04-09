{
  config,
  pkgs,
  ...
}: let
  mkcert.certs = pkgs.runCommand "mkcert-certs" {} ''
    CAROOT=$out ${pkgs.mkcert}/bin/mkcert -install
  '';
in {
  home-manager.users.${config.wellKnown.username} = {
    home.file.".local/share/mkcert/rootCA.pem".source = "${mkcert.certs}/rootCA.pem";
    home.file.".local/share/mkcert/rootCA-key.pem".source = "${mkcert.certs}/rootCA-key.pem";
  };

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [];
  networking.firewall.allowedTCPPorts = [];

  networking.hostName = "machine";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  networking.networkmanager.enable = true;

  security.pki.certificateFiles = ["${mkcert.certs}/rootCA.pem"];

  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];

  virtualisation.oci-containers.containers.cloudflared-tunnel = {
    image = "cloudflare/cloudflared:latest";
    cmd = ["tunnel" "--no-autoupdate" "run"];
    extraOptions = ["--network" "host"];
    environmentFiles = [config.sops.secrets.cloudflared-tunnel.path];
  };
}
