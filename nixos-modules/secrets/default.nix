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
    home-manager.users.${config.wellKnown.username} = {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "github.com" = {
          identityFile = "${config.secrets.path}/ssh/kamadorueda";
        };
      };
    };
    programs.ssh.startAgent = true;
  };
}
