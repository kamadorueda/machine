{lib, ...}: {
  options = {
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
}
