{
  config,
  nixpkgs,
  ...
}: {
  containers.postgresql = {
    autoStart = false;
    config = {
      services.postgresql = {
        package = nixpkgs.postgresql;
        enable = true;
        enableTCPIP = false;
        authentication = ''
          local all all trust
          host all all 127.0.0.1/32 trust
          host all all ::1/128 trust
        '';
        settings = {
          full_page_writes = false;
          fsync = false;
          shared_buffers = 128;
          synchronous_commit = false;
          timezone = "UTC";
        };
      };

      services.pgadmin.enable = true;
      services.pgadmin.port = 10000 + config.services.postgresql.settings.port;
      services.pgadmin.initialEmail = config.wellKnown.email;
      services.pgadmin.initialPasswordFile = builtins.toFile "password" "123456";
    };
    ephemeral = true;
  };
}
