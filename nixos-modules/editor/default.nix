{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.lists) concatLists;
  inherit (pkgs.lib.meta) getExe;

  extensionsDir = "/data/editor/extensions";
  userDataDir = "/data/editor/data";

  pkg = pkgs.alias "editor" pkgs.vscode (concatLists [
    ["--extensions-dir" extensionsDir]
    ["--user-data-dir" userDataDir]
  ]);
  bin = getExe pkg;

  extensions = import ./extensions.nix {inherit pkgs;};

  settings = import ./settings.nix {inherit config pkgs;};

  settingsJson = (pkgs.formats.json {}).generate "settings.json" settings;
in {
  environment.systemPackages = [pkg];

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
      substitutions = concatLists [
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
