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
    secrets.path = "/data/github/kamadorueda/secrets";
  };
}
