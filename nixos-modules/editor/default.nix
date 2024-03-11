{
  config,
  fenix,
  nixpkgs,
  ...
}: let
  pkg = nixpkgs.vscode;

  extensionsDir = "/data/editor/extensions";
  userDataDir = "/data/editor/data";

  bin =
    nixpkgs.lib.pipe
    [
      ["${pkg}/bin/code"] # unfree
      ["--extensions-dir" extensionsDir]
      ["--user-data-dir" userDataDir]
    ]
    [
      nixpkgs.lib.flatten
      nixpkgs.lib.escapeShellArgs
    ];

  extensions = import ./extensions.nix {inherit fenix nixpkgs;};

  settings = import ./settings.nix {inherit config fenix nixpkgs;};

  settingsJson =
    nixpkgs.runCommand "settings.json" {
      passAsFile = ["settings"];
      settings = builtins.toJSON settings;
    }
    "cp $settingsPath $out";
in {
  environment.variables.EDITOR = "${bin} --wait";
  environment.systemPackages = [
    pkg
    (nixpkgs.writeShellScriptBin "editor" ''
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
    script = toString (nixpkgs.substitute {
      src = nixpkgs.writeShellScript "machine-editor-setup.sh" ''
        set -eux

        export PATH=${nixpkgs.lib.makeSearchPath "bin" [nixpkgs.coreutils]}

        rm -rf "@userDataDir@"
        rm -rf "@extensionsDir@"

        mkdir -p "@userDataDir@/User"
        mkdir -p "@extensionsDir@"

        cp --dereference --no-preserve=mode,ownership \
          "@settings@" "@userDataDir@/User/settings.json"
        cp --dereference --no-preserve=mode,ownership -rT \
          "@extensions@/share/vscode/extensions/" "@extensionsDir@"
      '';
      replacements = [
        ["--replace" "@extensions@" extensions]
        ["--replace" "@extensionsDir@" extensionsDir]
        ["--replace" "@settings@" settingsJson]
        ["--replace" "@userDataDir@" userDataDir]
      ];
      isExecutable = true;
    });
    serviceConfig = {
      Group = config.users.users.${config.wellKnown.username}.group;
      Type = "oneshot";
      User = config.wellKnown.username;
    };
  };
}
