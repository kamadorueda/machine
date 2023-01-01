{
  config,
  lib,
  nixpkgs,
  ...
}: {
  options = {
    fhs.packages = lib.mkOption {
      type = lib.types.listOf lib.types.path;
    };
    fhs.paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["/include" "/lib" "/lib64"];
    };
  };

  config = {
    fileSystems = let
      fhsLinks = nixpkgs.buildEnv {
        name = "fhs-links";
        paths = config.fhs.packages;
      };

      fhs = nixpkgs.runCommand "fhs" {} "cp -rL ${fhsLinks} $out";
    in
      builtins.listToAttrs
      (builtins.map
        (path: {
          name = path;
          value = {
            device = "${fhs}${path}";
            options = ["bind"];
          };
        })
        config.fhs.paths);
  };
}
