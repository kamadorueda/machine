{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    secrets.ageKeyPath = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.systemPackages = [pkgs.gnupg];
    programs.ssh.startAgent = true;
  };
}
