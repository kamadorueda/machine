{
  config,
  flakeInputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.attrsets) recursiveUpdate;

  baseContainer = {
    autoStart = false;
    bindMounts."/data/nixpkgs".hostPath = "/data/nixpkgs";
    ephemeral = true;
  };
  baseConfig = {
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

    sops.age.keyFile = "/age-key.txt";
    sops.secrets.buildkite-token.owner = "buildkite-agent-default";
  };
in {
  sops.secrets."buildkite-public-age-key" = {
    restartUnits = ["container@buildkite-public.service"];
  };

  containers.buildkite-public = recursiveUpdate baseContainer {
    bindMounts."/age-key.txt".hostPath = "/run/secrets/buildkite-public-age-key";
    config = recursiveUpdate baseConfig {
      sops.defaultSopsFile = ../../secrets/buildkite-public.yaml;
    };
  };

  sops.secrets."buildkite-private-age-key" = {
    restartUnits = ["container@buildkite-private.service"];
  };

  containers.buildkite-private = recursiveUpdate baseContainer {
    bindMounts."/age-key.txt".hostPath = "/run/secrets/buildkite-private-age-key";
    config = {config, ...}:
      recursiveUpdate baseConfig {
        services.buildkite-agents.default = {
          hooks.environment = ''
            # shellcheck disable=SC1091
            source ${config.sops.templates.environment-hook.path}
          '';
          tags.queue = "private";
        };

        sops.defaultSopsFile = ../../secrets/buildkite-private.yaml;

        sops.secrets.buildkite-token = {};
        sops.secrets.cachix-auth-token-alejandra = {};
        sops.secrets.coveralls-kamadorueda-alejandra = {};
        sops.secrets.coveralls-kamadorueda-nixel = {};
        sops.secrets.coveralls-kamadorueda-santiago = {};
        sops.secrets.coveralls-kamadorueda-toros = {};
        sops.templates.environment-hook.content = ''
          export PAGER=

          case "$BUILDKITE_PIPELINE_NAME" in
            alejandra)
              case "$BUILDKITE_BRANCH" in
                main)
                  export CACHIX_AUTH_TOKEN="${config.sops.placeholder.cachix-auth-token-alejandra}"
                  export COVERALLS_REPO_TOKEN="${config.sops.placeholder.coveralls-kamadorueda-alejandra}"
                  ;;
              esac
              ;;
            nixel)
              case "$BUILDKITE_BRANCH" in
                main)
                  export COVERALLS_REPO_TOKEN="${config.sops.placeholder.coveralls-kamadorueda-nixel}"
                  ;;
              esac
              ;;
            santiago)
              case "$BUILDKITE_BRANCH" in
                main)
                  export COVERALLS_REPO_TOKEN="${config.sops.placeholder.coveralls-kamadorueda-santiago}"
                  ;;
              esac
              ;;
            toros)
              case "$BUILDKITE_BRANCH" in
                main)
                  export COVERALLS_REPO_TOKEN="${config.sops.placeholder.coveralls-kamadorueda-toros}"
                  ;;
              esac
              ;;
          esac
        '';
      };
  };
}
