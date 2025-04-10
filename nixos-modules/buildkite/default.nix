{
  config,
  flakeInputs,
  pkgs,
  ...
}: let
  baseConfig = {
    autoStart = true;
    bindMounts."/data/nixpkgs".hostPath = "/data/nixpkgs";
    config = {
      imports = [flakeInputs.sopsNix.nixosModules.sops];

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
          pkgs.bash
          pkgs.cachix
          pkgs.direnv
          pkgs.git
          pkgs.gnugrep
          pkgs.gnutar
          pkgs.gzip
          (pkgs.writeShellScriptBin "nix-env" ''
            exec ${config.nix.package}/bin/nix-env "$@"
          '')
          (pkgs.writeShellScriptBin "nix-store" ''
            exec ${config.nix.package}/bin/nix-store "$@"
          '')
          (pkgs.writeShellScriptBin "nix" ''
            exec ${config.nix.package}/bin/nix --print-build-logs "$@"
          '')
        ];
        shell = "${pkgs.bash}/bin/bash -euo pipefail -c";
        tokenPath = "/run/secrets/buildkite-token";
      };
    };
    ephemeral = true;
  };
in {
  containers.buildkite-public =
    pkgs.lib.attrsets.recursiveUpdate
    baseConfig
    {
      bindMounts."/age-key.txt".hostPath = "/run/secrets/buildkite-public-age-key";
      config = {
        sops.age.keyFile = "/age-key.txt";
        sops.defaultSopsFile = ../../secrets/buildkite-public.yaml;

        sops.secrets.buildkite-token = {
          owner = "buildkite-agent-default";
        };
      };
    };
  containers.buildkite-private =
    pkgs.lib.attrsets.recursiveUpdate
    baseConfig
    {
      bindMounts."/age-key.txt".hostPath = "/run/secrets/buildkite-private-age-key";
      config = {
        sops.age.keyFile = "/age-key.txt";
        sops.defaultSopsFile = ../../secrets/buildkite-private.yaml;

        sops.secrets.buildkite-token = {
          owner = "buildkite-agent-default";
        };
        sops.secrets.cachix-auth-token-alejandra = {
          owner = "buildkite-agent-default";
        };
        sops.secrets.coveralls-kamadorueda-alejandra = {
          owner = "buildkite-agent-default";
        };
        sops.secrets.coveralls-kamadorueda-nixel = {
          owner = "buildkite-agent-default";
        };
        sops.secrets.coveralls-kamadorueda-santiago = {
          owner = "buildkite-agent-default";
        };
        sops.secrets.coveralls-kamadorueda-toros = {
          owner = "buildkite-agent-default";
        };
      };
      config.services.buildkite-agents.default = {
        hooks.environment = ''
          export PAGER=

          case "$BUILDKITE_PIPELINE_NAME" in
            alejandra)
              case "$BUILDKITE_BRANCH" in
                main)
                  CACHIX_AUTH_TOKEN="$(cat /run/secrets/cachix-auth-token-alejandra)"
                  export CACHIX_AUTH_TOKEN

                  COVERALLS_REPO_TOKEN="$(cat /run/secrets/coveralls-kamadorueda-alejandra)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            nixel)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /run/secrets/coveralls-kamadorueda-nixel)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            santiago)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /run/secrets/coveralls-kamadorueda-santiago)"
                  export COVERALLS_REPO_TOKEN
                  ;;
              esac
              ;;
            toros)
              case "$BUILDKITE_BRANCH" in
                main)
                  COVERALLS_REPO_TOKEN="$(cat /run/secrets/coveralls-kamadorueda-toros)"
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
