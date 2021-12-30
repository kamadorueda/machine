{ lib, ... }:

{
  options.wellKnown.email = lib.mkOption {
    type = lib.types.string;
  };
}
