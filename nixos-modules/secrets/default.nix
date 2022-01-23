{ config
, lib
, nixpkgs
, ...
}:

{
  options = {
    secrets.hashedPassword = lib.mkOption {
      type = lib.types.str;
    };
    secrets.path = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    environment.variables.GNUPGHOME = "${config.secrets.path}/machine/gpg/home";
    environment.variables.SECRETS = config.secrets.path;
    environment.systemPackages = [ nixpkgs.gnupg ];
    home-manager.users.${config.wellKnown.username} = {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        "core" = {
          forwardAgent = true;
          host = "core.floxdev.com";
          identityFile = "${config.secrets.path}/machine/ssh/kamadorueda";
        };
        "github.com" = {
          identityFile = "${config.secrets.path}/machine/ssh/kamadorueda";
        };
      };
    };
    programs.ssh.startAgent = true;
  };
}
