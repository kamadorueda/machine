{
  config,
  nixpkgs,
  ...
}: {
  containers.mysql = {
    autoStart = false;
    config = {
      services.mysql.enable = true;
      services.mysql.package = nixpkgs.mysql;
      services.mysql.user = "root";
      services.mysql.initialScript = ./init.sql;
    };
    ephemeral = true;
  };
}
