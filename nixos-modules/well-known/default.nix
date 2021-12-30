{ config
, lib
, ...
}:

{

  options = {
    wellKnown.email = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.hashedPassword = lib.mkOption {
      type = lib.types.str;
    };
    wellKnown.home = lib.mkOption {
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
