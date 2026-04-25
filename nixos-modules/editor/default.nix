{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.lists) concatLists;
  inherit (pkgs.lib.meta) getExe;

  dataDir = "${config.wellKnown.dataDir}/editor";

  zed = pkgs.alias "zed" pkgs.zed-editor ["--user-data-dir" dataDir];

  settings = import ./settings.nix {inherit config pkgs;};

  settingsJson = (pkgs.formats.json {}).generate "settings.json" settings;
in {
  config = {
    wellKnown.editor = zed;

    environment.variables.EDITOR = "editor --wait";
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

          rm -rf "@dataDir@/config"
          mkdir -p "@dataDir@/config"

          cp --dereference --no-preserve=mode,ownership \
            "@settings@" "@dataDir@/config/settings.json"
        '';
        substitutions = concatLists [
          ["--replace-fail" "@dataDir@" dataDir]
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
