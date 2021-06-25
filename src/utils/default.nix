_: with _; {
  debug = expr: builtins.trace expr expr;
  remoteImport = { args ? null, source }:
    if args == null
    then import source
    else import source args;
  script =
    { env ? { }
    , path ? [ ]
    , src
    }:
    let
      export = k: v: "${k}=${packages.nixpkgs.lib.escapeShellArg v}";
      exports = packages.nixpkgs.lib.mapAttrsToList export (env // {
        PATH = packages.nixpkgs.lib.makeBinPath (path ++ [
          packages.nixpkgs.coreutils
        ]);
      });
    in
    ''
      ${builtins.concatStringsSep " " exports} \
        ${packages.nixpkgs.bash}/bin/bash -euo pipefail ${src}
    '';
}
