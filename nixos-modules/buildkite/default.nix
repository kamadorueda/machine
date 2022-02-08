{ config
, nixpkgs
, ...
}:
{
  services.buildkite-agents.default = {
    hooks.environment = "source ${config.secrets.path}/machine/secrets.sh";
    runtimePackages = [
      nixpkgs.bash
      nixpkgs.cachix
      nixpkgs.git
      nixpkgs.gnutar
      nixpkgs.gzip
      nixpkgs.nix
      (
        nixpkgs.writeShellScriptBin "nix3" ''
          exec ${nixpkgs.nixUnstable}/bin/nix \
            --experimental-features nix-command \
            --experimental-features flakes \
            --print-build-logs \
            "$@"
        ''
      )
    ];
    shell = "${nixpkgs.bash}/bin/bash -euo pipefail -c";
    tokenPath = "${config.secrets.path}/machine/buildkite-token";
  };
}
