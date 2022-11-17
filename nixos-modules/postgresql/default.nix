{nixpkgs, ...}: {
  services.postgresql = {
    package = nixpkgs.postgresql_15;
    enable = true;
    enableTCPIP = false;
    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    settings = {
      timezone = "UTC";
      shared_buffers = 128;
      fsync = false;
      synchronous_commit = false;
      full_page_writes = false;
    };
  };
}
