{
  config,
  flakeInputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.overlays = [
    flakeInputs.fenix.overlays.default
    (final: prev: let
      inherit (final.lib.meta) getExe getExe';
      inherit (final.lib.strings) escapeShellArgs;
    in {
      alias = to: pkg: final.alias' to pkg pkg.meta.mainProgram;

      alias' = to: pkg: from: extraArgs:
        final.writeShellApplication {
          name = to;
          runtimeEnv = {
            EXTRA_ARGS = extraArgs;
          };
          text = ''
            exec ${getExe' pkg from} "''${EXTRA_ARGS[@]}" "$@"
          '';
        };
    })
  ];
}
