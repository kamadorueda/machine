{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    secrets.hashedPassword = lib.mkOption {type = lib.types.str;};
    secrets.path = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.variables.GNUPGHOME = "${config.secrets.path}/gpg/home";
    environment.systemPackages = [pkgs.gnupg];
    programs.ssh.startAgent = true;
  };
}
