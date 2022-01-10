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
      home.file.".ssh/config" = {
        source = "${config.secrets.path}/machine/ssh/config";
      };
    };
  };
}
