{
  config,
  lib,
  nixpkgs,
  ...
}: {
  options = {
    secrets.hashedPassword = lib.mkOption {type = lib.types.str;};
    secrets.path = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.variables.GNUPGHOME = "${config.secrets.path}/gpg/home";
    environment.systemPackages = [nixpkgs.gnupg];
    programs.ssh.startAgent = true;
  };
}
