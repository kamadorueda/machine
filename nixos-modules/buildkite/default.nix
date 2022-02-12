{ config
, nixpkgs
, ...
}:
let
  baseConfig = {
    bindMounts."/secrets/buildkite-token" = {
      hostPath = "${config.secrets.path}/machine/buildkite-token";
    };
    config.services.buildkite-agents.default = {
      runtimePackages = [
        nixpkgs.bash
        nixpkgs.cachix
        nixpkgs.direnv
        nixpkgs.git
        nixpkgs.gnugrep
        nixpkgs.gnutar
        nixpkgs.gzip
        nixpkgs.nix
        (
          nixpkgs.writeShellScriptBin "nix3" ''
            exec ${nixpkgs.nixUnstable}/bin/nix \
              --extra-experimental-features nix-command \
              --extra-experimental-features flakes \
              --print-build-logs \
              "$@"
          ''
        )
      ];
      shell = "${nixpkgs.bash}/bin/bash -euo pipefail -c";
      tokenPath = "/secrets/buildkite-token";
    };
    ephemeral = true;
  };
in
{
  containers.buildkite-public =
    nixpkgs.lib.attrsets.recursiveUpdate
    { }
    baseConfig;
  containers.buildkite-private =
    nixpkgs.lib.attrsets.recursiveUpdate
    {
      bindMounts."/secrets/cachix-auth-token-alejandra" = {
        hostPath = "${config.secrets.path}/machine/cachix-auth-token-alejandra";
      };
      bindMounts."/secrets/coveralls-kamadorueda-alejandra" = {
        hostPath = "${config.secrets.path}/machine/coveralls-kamadorueda-alejandra";
      };
      config.services.buildkite-agents.default = {
        hooks.environment = ''
          export PAGER=

          case "$BUILDKITE_PIPELINE_NAME" in
            alejandra)
              case "$BUILDKITE_BRANCH" in
                main)
                  export CACHIX_AUTH_TOKEN="$(cat /secrets/cachix-auth-token-alejandra)"
                  export COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-alejandra)"
                  ;;
              esac
              ;;
          esac
        '';
        tags.queue = "private";
      };
    }
    baseConfig;
}
