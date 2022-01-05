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
        "github.com" = {
          extraOptions.PreferredAuthentications = "publickey";
          identityFile = "${config.secrets.path}/machine/ssh/kamadorueda";
        };
        "gitlab.com" = {
          extraOptions.PreferredAuthentications = "publickey";
          identityFile = "${config.secrets.path}/machine/ssh/kamadorueda";
        };
      };
    };
  };
}
