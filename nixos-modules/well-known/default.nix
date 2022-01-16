{ config
, lib
, ...
}:

let
  strOption = lib.mkOption {
    type = lib.types.str;
  };
in
{

  options = {
    wellKnown.email = strOption;
    wellKnown.home = strOption;
    wellKnown.name = strOption;
    wellKnown.signingKey = strOption;
    wellKnown.username = strOption;
  };

  config = {
    wellKnown.home = "/home/${config.wellKnown.username}";
  };

}
