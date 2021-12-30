{ lib
, nixpkgs
, ...
}:

{

  options = {
    editor.bin = lib.mkOption {
      type = lib.types.str;
    };
  };

  config =
    let
      bin = builtins.concatStringsSep " " [
        "${nixpkgs.vscode}/bin/code"
        "--extensions-dir"
        extensionsDir
        "--user-data-dir"
        userDataDir
      ];
      extensionsDir = "/data/vscode/extensions";
      userDataDir = "/data/vscode/data";
    in
    {
      editor.bin = bin;
      environment.variables.EDITOR = bin;
      environment.systemPackages = [ nixpkgs.vscode ];
    };

}
