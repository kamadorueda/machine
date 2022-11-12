{nixpkgs, ...}: {
  services.mysql.enable = true;
  services.mysql.package = nixpkgs.mysql;
  services.mysql.user = "root";
}
