{ config
, lib
, ...
}:


{
  options = {
    secrets.path = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    environment.variables.GNUPGHOME = "${config.secrets.path}/machine/gpg/home";
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
    secrets.path = "/data/github/kamadorueda/secrets";
  };
}
