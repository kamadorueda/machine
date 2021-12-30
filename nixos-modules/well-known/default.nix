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
    wellKnown.paths = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
    wellKnown.username = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    wellKnown.paths.home = "/home/${config.wellKnown.username}";
  };

}
