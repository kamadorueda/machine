{ config
, nixpkgs
, ...
}:
{
  containers.buildkite = {
    autoStart = true;
    bindMounts."/secrets/buildkite-token" = {
      hostPath = "${config.secrets.path}/machine/buildkite-token";
    };
    bindMounts."/secrets/cachix-auth-token-alejandra" = {
      hostPath = "${config.secrets.path}/machine/cachix-auth-token-alejandra";
    };
    config.services.buildkite-agents.default = {
      hooks.environment = ''
        export PAGER=

        case "$BUILDKITE_PIPELINE_NAME" in
          alejandra)
            case "$BUILDKITE_BRANCH" in
              main)
                export CACHIX_AUTH_TOKEN="$(cat /secrets/cachix-auth-token-alejandra)"
                ;;
            esac
            ;;
        esac
      '';
      runtimePackages = [
        nixpkgs.bash
        nixpkgs.cachix
        nixpkgs.direnv
        nixpkgs.git
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
    extraFlags = [
      "--private-users=pick"
      "--private-users-ownership=auto"
    ];
  };
}
