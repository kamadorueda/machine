{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.lists) concatLists;

  configDir = "${config.wellKnown.dataDir}/.claude";

  settings = import ./settings.nix {inherit config pkgs;};

  settingsJson = (pkgs.formats.json {}).generate "settings.json" settings;
in {
  config = {
    environment.systemPackages = [pkgs.claude-code];

    systemd.services."machine-claude-code-setup" = {
      script = toString (pkgs.substitute {
        src = pkgs.writeShellScript "machine-claude-code-setup.sh" ''
          set -eux

          mkdir -p "@configDir@"

          cp --dereference --no-preserve=mode,ownership \
            "@settings@" "@configDir@/settings.json"
        '';
        substitutions = concatLists [
          ["--replace-fail" "@configDir@" configDir]
          ["--replace-fail" "@settings@" settingsJson]
        ];
        isExecutable = true;
      });
      serviceConfig = {
        RemainAfterExit = true;
        Type = "oneshot";
      };
      unitConfig = {
        After = ["multi-user.target"];
      };
      requiredBy = ["multi-user.target"];
    };
  };
}
