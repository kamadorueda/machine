{ config
, nixpkgs
, ...
}:
let
  baseConfig = {
    autoStart = true;
    bindMounts."/secrets/buildkite-token" = {
      hostPath = "${config.secrets.path}/machine/buildkite-token";
    };
    bindMounts."/data/nixpkgs" = {
      hostPath = "/data/nixpkgs";
    };
    config = {
      nix.extraOptions = ''
        extra-experimental-features = nix-command flakes
      '';
      nix.settings.cores = 1;
      nix.settings.max-jobs = 1;
      nix.package = nixpkgs.nixUnstable;
      services.buildkite-agents.default = {
        hooks.environment = ''
          export PAGER=
        '';
        runtimePackages = [
          nixpkgs.bash
          nixpkgs.cachix
          nixpkgs.direnv
          nixpkgs.git
          nixpkgs.gnugrep
          nixpkgs.gnutar
          nixpkgs.gzip
          (
            nixpkgs.writeShellScriptBin "nix" ''
              exec ${nixpkgs.nixUnstable}/bin/nix \
                --print-build-logs \
                "$@"
            ''
          )
        ];
        shell = "${nixpkgs.bash}/bin/bash -euo pipefail -c";
        tokenPath = "/secrets/buildkite-token";
      };
    };
    ephemeral = true;
  };
in
{
  containers.buildkite-public =
    nixpkgs.lib.attrsets.recursiveUpdate
    baseConfig
    { };
  containers.buildkite-private =
    nixpkgs.lib.attrsets.recursiveUpdate
    baseConfig
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
    };
}
