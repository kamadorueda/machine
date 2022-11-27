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
      services.mysql.initialScript = builtins.toFile "startup.sql" ''
        CREATE USER 'kevin'@'localhost' IDENTIFIED BY '123';
        GRANT ALL PRIVILEGES ON *.* TO 'kevin'@'localhost' WITH GRANT OPTION;
        FLUSH PRIVILEGES;

        CREATE DATABASE IF NOT EXISTS cinema;
      '';
    };
    ephemeral = true;
  };
}
