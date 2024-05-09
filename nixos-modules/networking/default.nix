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
    serviceConfig = {
      ExecStart = nixpkgs.writeShellScript "exec-start.sh" ''
        set -eux

        system_conections=/etc/NetworkManager/system-connections

        mkdir -p "$system_conections"

        for connection_config in ${config.secrets.path}/wifi-*
        do
          connection_name=$(basename "$connection_config")

          cp "$connection_config" "$system_conections/$connection_name"
          chmod 400 "$system_conections/$connection_name"
        done
      '';
      RemainAfterExit = true;
      Type = "oneshot";
    };

    requiredBy = ["NetworkManager.service"];
  };

  users.users.${config.wellKnown.username}.extraGroups = ["networkmanager"];

  virtualisation.oci-containers.containers.cloudflared-tunnel = {
    image = "cloudflare/cloudflared:latest";
    cmd = ["tunnel" "--no-autoupdate" "run"];
    extraOptions = ["--network" "host"];
    environmentFiles = ["${config.secrets.path}/cloudflared-tunnel"];
  };
}
