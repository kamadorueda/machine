{ config
, lib
, ...
}:

{

  options = {
    wellKnown.email = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.home = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.name = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.signingKey = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.username = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    wellKnown.home = "/home/${config.wellKnown.username}";
  };

}
