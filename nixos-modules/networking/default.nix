{
  config,
  nixpkgs,
  ...
}: {
  networking.hostName = "machine";
  networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
  networking.networkmanager.enable = true;
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
}
