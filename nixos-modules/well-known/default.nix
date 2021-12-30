{ lib, ... }:

{
  options.wellKnown.email = lib.mkOption {
    type = lib.types.str;
  };
  options.wellKnown.username = lib.mkOption {
    type = lib.types.str;
  };
}
