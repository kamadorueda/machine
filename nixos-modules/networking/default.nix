{
  config,
  nixpkgs,
  ...
}: let
  mkcert.certs = nixpkgs.runCommand "mkcert-certs" {} ''
    CAROOT=$out ${nixpkgs.mkcert}/bin/mkcert -install
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

  systemd.services."machine-networking-setup" = {
    description = "Machine's networking setup";
    script = ''
      set -eux

      export PATH=${nixpkgs.lib.makeSearchPath "bin" [nixpkgs.coreutils]}

      mkdir -p /etc/NetworkManager/system-connections
      cd /etc/NetworkManager/system-connections

      for connection in \
        wifi-airuc-secure \
        wifi-eduroam \
        wifi-spsetup-2c38 \

      do
        cp ${config.secrets.path}/$connection $connection
        chmod 400 $connection
      done
    '';
    serviceConfig.Type = "oneshot";
    wantedBy = ["NetworkManager.service"];
  };

  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];

  virtualisation.oci-containers.containers.cloudflared-tunnel = {
    image = "cloudflare/cloudflared:latest";
    cmd = ["tunnel" "--no-autoupdate" "run"];
    extraOptions = ["--network" "host"];
    environmentFiles = ["${config.secrets.path}/cloudflared-tunnel"];
  };
}
