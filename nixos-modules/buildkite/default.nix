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
        sops.templates.environment-hook = {
          file = let
            app = pkgs.writeShellApplication {
              name = "buildkite-environment-hook";
              runtimeEnv = {
                CACHIX_AUTH_TOKEN_ALEJANDRA = config.sops.placeholder.cachix-auth-token-alejandra;
                COVERALLS_KAMADORUEDA_ALEJANDRA = config.sops.placeholder.coveralls-kamadorueda-alejandra;
                COVERALLS_KAMADORUEDA_NIXEL = config.sops.placeholder.coveralls-kamadorueda-nixel;
                COVERALLS_KAMADORUEDA_SANTIAGO = config.sops.placeholder.coveralls-kamadorueda-santiago;
                COVERALLS_KAMADORUEDA_TOROS = config.sops.placeholder.coveralls-kamadorueda-toros;
              };
              text = builtins.readFile ./environment-hook.sh;
            };
          in "${app}/bin/${app.name}";
          owner = "buildkite-agent-default";
        };
      };
  };
}
