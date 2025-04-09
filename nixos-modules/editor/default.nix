{
  config,
  pkgs,
  ...
}: let
  pkg = pkgs.vscode;

  extensionsDir = "/data/editor/extensions";
  userDataDir = "/data/editor/data";

  bin =
    pkgs.lib.pipe
    [
      ["${pkg}/bin/code"] # unfree
      ["--extensions-dir" extensionsDir]
      ["--user-data-dir" userDataDir]
    ]
    [
      (pkgs.lib.flatten)
      (pkgs.lib.concatStringsSep " ")
    ];

  extensions = import ./extensions.nix {inherit pkgs;};

  settings = import ./settings.nix {inherit config pkgs;};

  settingsJson =
    pkgs.runCommand "settings.json" {
      passAsFile = ["settings"];
      settings = builtins.toJSON settings;
    }
    "cp $settingsPath $out";
in {
  environment.variables.EDITOR = "${bin} --wait";
  environment.systemPackages = [
    pkg
    (pkgs.writeShellScriptBin "editor" ''
      exec ${bin} "$@"
    '')
  ];

  home-manager.users.${config.wellKnown.username} = {
    home.file.".config/rustfmt/rustfmt.toml".source = ./rustfmt.toml;
  };

  programs.git.config = {
    diff.tool = "editor";
    difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
    merge.tool = "editor";
    mergetool.editor.cmd = "${bin} --wait $MERGED";
  };

  systemd.services."machine-editor-setup" = {
    script = toString (pkgs.substitute {
      src = pkgs.writeShellScript "machine-editor-setup.sh" ''
        set -eux

        rm -rf "@userDataDir@"
        rm -rf "@extensionsDir@"

        mkdir -p "@userDataDir@/User"
        mkdir -p "@extensionsDir@"

        cp --dereference --no-preserve=mode,ownership \
          "@settings@" "@userDataDir@/User/settings.json"
        cp --dereference --no-preserve=mode,ownership -rT \
          "@extensions@/share/vscode/extensions/" "@extensionsDir@"
      '';
      substitutions = pkgs.lib.concatLists [
        ["--replace-fail" "@extensions@" extensions]
        ["--replace-fail" "@extensionsDir@" extensionsDir]
        ["--replace-fail" "@settings@" settingsJson]
        ["--replace-fail" "@userDataDir@" userDataDir]
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
}
