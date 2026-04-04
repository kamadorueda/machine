{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.lists) concatLists;
  inherit (pkgs.lib.meta) getExe;

  configDir = "/data/editor/config";

  basePackage = pkgs.zed-editor;

  zed = pkgs.writeShellApplication {
    name = "zed";
    runtimeEnv = {
      ZED_CONFIG_DIR = configDir;
    };
    text = ''exec ${getExe basePackage} "$@"'';
  };

  settings = import ./settings.nix {inherit config pkgs;};

  settingsJson = (pkgs.formats.json {}).generate "settings.json" settings;
in {
  options = {
    wellKnown.editor = lib.mkOption {
      type = lib.types.package;
      description = "The zed editor package with config directory preconfigured";
    };
  };

  config = {
    wellKnown.editor = zed;

    environment.variables.EDITOR = "editor";
    environment.systemPackages = [zed];

    home-manager.users.${config.wellKnown.username} = {
      home.file.".config/rustfmt/rustfmt.toml".source = ./rustfmt.toml;
    };

    programs.git.config = {
      diff.tool = "editor";
      difftool.editor.cmd = "editor --wait --diff $LOCAL $REMOTE";
      merge.tool = "editor";
      mergetool.editor.cmd = "editor --wait $MERGED";
    };

    systemd.services."machine-editor-setup" = {
      script = toString (pkgs.substitute {
        src = pkgs.writeShellScript "machine-editor-setup.sh" ''
          set -eux

          rm -rf "@configDir@"
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
        Group = config.users.users.${config.wellKnown.username}.group;
        RemainAfterExit = true;
        Type = "oneshot";
        User = config.wellKnown.username;
      };
      unitConfig = {
        After = ["multi-user.target"];
      };
      requiredBy = ["graphical.target"];
    };
  };
}
