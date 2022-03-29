{
  config,
  nixpkgs,
  ...
}: let
  baseConfig = {
    autoStart = false;
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
          (nixpkgs.writeShellScriptBin "nix-env" ''
            exec ${nixpkgs.nixUnstable}/bin/nix-env "$@"
          '')
          (nixpkgs.writeShellScriptBin "nix-store" ''
            exec ${nixpkgs.nixUnstable}/bin/nix-store "$@"
          '')
          (nixpkgs.writeShellScriptBin "nix" ''
            exec ${nixpkgs.nixUnstable}/bin/nix --print-build-logs "$@"
          '')
        ];
        shell = "${nixpkgs.bash}/bin/bash -euo pipefail -c";
        tokenPath = "/secrets/buildkite-token";
      };
    };
    ephemeral = true;
  };
in {
  containers.buildkite-public =
    nixpkgs.lib.attrsets.recursiveUpdate
    baseConfig
    {};
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
      bindMounts."/secrets/coveralls-kamadorueda-santiago" = {
        hostPath = "${config.secrets.path}/machine/coveralls-kamadorueda-santiago";
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
            santiago)
              case "$BUILDKITE_BRANCH" in
                main)
                  export COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-santiago)"
                  ;;
              esac
              ;;
          esac
        '';
        tags.queue = "private";
      };
    };
}
