{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    secrets.hashedPasswordFile = lib.mkOption {type = lib.types.str;};
    secrets.ageKeyPath = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.systemPackages = [pkgs.gnupg];
    programs.ssh.startAgent = true;
  };
}
