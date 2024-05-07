{
  config,
  nixpkgs,
  ...
}: let
  baseConfig = {
    autoStart = false;
    bindMounts."/secrets/buildkite-token" = {
      hostPath = "${config.secrets.path}/buildkite-token";
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
      nix.settings.substituters = config.nix.settings.substituters;
      nix.settings.trusted-public-keys = config.nix.settings.trusted-public-keys;
      nix.package = config.nix.package;
      services.buildkite-agents.default = {
        extraConfig = ''
          no-git-submodules = true
        '';
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
            exec ${config.nix.package}/bin/nix-env "$@"
          '')
          (nixpkgs.writeShellScriptBin "nix-store" ''
            exec ${config.nix.package}/bin/nix-store "$@"
          '')
          (nixpkgs.writeShellScriptBin "nix" ''
            exec ${config.nix.package}/bin/nix --print-build-logs "$@"
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
        hostPath = "${config.secrets.path}/cachix-auth-token-alejandra";
      };
      bindMounts."/secrets/coveralls-kamadorueda-alejandra" = {
        hostPath = "${config.secrets.path}/coveralls-kamadorueda-alejandra";
      };
      bindMounts."/secrets/coveralls-kamadorueda-nixel" = {
        hostPath = "${config.secrets.path}/coveralls-kamadorueda-nixel";
      };
      bindMounts."/secrets/coveralls-kamadorueda-santiago" = {
        hostPath = "${config.secrets.path}/coveralls-kamadorueda-santiago";
      };
      bindMounts."/secrets/coveralls-kamadorueda-toros" = {
        hostPath = "${config.secrets.path}/coveralls-kamadorueda-toros";
      };
      config.services.buildkite-agents.default = {
        hooks.environment = ''
          export PAGER=

          case "$BUILDKITE_PIPELINE_NAME" in
            alejandra)
              case "$BUILDKITE_BRANCH" in
                main)
                  CACHIX_AUTH_TOKEN="$(cat /secrets/cachix-auth-token-alejandra)"
                  export CACHIX_AUTH_TOKEN

                  COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-alejandra)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            nixel)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-nixel)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            santiago)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-santiago)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            toros)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /secrets/coveralls-kamadorueda-toros)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
          esac
        '';
        tags.queue = "private";
      };
    };
}
