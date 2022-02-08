{ config
, nixpkgs
, ...
}:
{
  services.buildkite-agents.default = {
    hooks.environment = ''
      case "$BUILDKITE_PIPELINE_NAME" in
        alejandra)
          case "$BUILDKITE_BRANCH" in
            main)
              export CACHIX_AUTH_TOKEN="$( \
                cat ${config.secrets.path}/machine/cachix-auth-token-alejandra)"
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
    tokenPath = "${config.secrets.path}/machine/buildkite-token";
  };
}
