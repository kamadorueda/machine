{lib, ...}: {
  options = {
    wellKnown.dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data";
      description = "Base directory for persistent data";
    };
    wellKnown.editor = lib.mkOption {
      type = lib.types.package;
      description = "The editor package with config directory preconfigured";
    };
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
}
