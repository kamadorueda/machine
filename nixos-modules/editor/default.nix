{ config
, lib
, makes
, makesSrc
, nixpkgs
, pythonOnNix
, ...
}:

let
  userDataDir = "/data/vscode/data";

  bin = builtins.concatStringsSep " " [
    "${nixpkgs.vscode}/bin/code"
    "--extensions-dir"
    "/data/vscode/extensions"
    "--user-data-dir"
    userDataDir
  ];
  extensions = [
    "bbenoist.Nix"
    "coolbear.systemd-unit-file"
    "eamodio.gitlens"
    "Gimly81.matlab"
    "hashicorp.terraform"
    "haskell.haskell"
    "jinliming2.vscode-go-template"
    "jkillian.custom-local-formatters"
    "justusadam.language-haskell"
    "mads-hartmann.bash-ide-vscode"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-vscode-remote.remote-ssh"
    "rust-lang.rust"
    "shardulm94.trailing-spaces"
    "streetsidesoftware.code-spell-checker"
    "tamasfe.even-better-toml"
  ];
  settings = {
    "[html]"."editor.formatOnSave" = false;
    "[python]"."editor.tabSize" = 4;
    "[rust]"."editor.tabSize" = 4;
    "customLocalFormatters.formatters" = [
      {
        command = "clang-format --sort-includes --style=microsoft";
        languages = [ "cpp" ];
      }
      {
        command = "${nixpkgs.jq}/bin/jq -S";
        languages = [ "json" "jsonc" ];
      }
      {
        command = "${nixpkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        languages = [ "nix" ];
      }
      {
        command =
          (nixpkgs.writeScript "python-fmt" ''
            #! ${nixpkgs.bash}/bin/bash

            ${pythonOnNix.black-latest-python39-bin}/bin/black \
              --config \
              ${makesSrc}/src/evaluator/modules/format-python/settings-black.toml \
              - \
              | \
            ${pythonOnNix.isort-latest-python39-bin}/bin/isort \
              --settings-path \
              ${makesSrc}/src/evaluator/modules/format-python/settings-isort.toml \
              -
          '').outPath;
        languages = [ "python" ];
      }
      {
        command = "${nixpkgs.rustfmt}/bin/rustfmt --config-path ${./rustfmt.toml}";
        languages = [ "rust" ];
      }
      {
        command = "${nixpkgs.shfmt}/bin/shfmt -bn -ci -i 2 -s -sr -";
        languages = [ "shellscript" ];
      }
      {
        command = "${nixpkgs.terraform}/bin/terraform fmt -";
        languages = [ "terraform" ];
      }
      {
        command =
          (nixpkgs.writeScript "toml-fmt" ''
            #! ${nixpkgs.bash}/bin/bash

            ${nixpkgs.yj}/bin/yj -tj \
              | ${nixpkgs.jq}/bin/jq -S \
              | ${nixpkgs.yj}/bin/yj -jti
          '').outPath;
        languages = [ "toml" ];
      }
    ];
    "diffEditor.ignoreTrimWhitespace" = false;
    "diffEditor.maxComputationTime" = 0;
    "diffEditor.renderSideBySide" = false;
    "diffEditor.wordWrap" = "on";
    "editor.cursorStyle" = "underline";
    "editor.defaultFormatter" = "jkillian.custom-local-formatters";
    "editor.bracketPairColorization.enabled" = true;
    "editor.formatOnPaste" = false;
    "editor.formatOnSave" = true;
    "editor.formatOnType" = false;
    "editor.fontFamily" = "'${config.ui.font}'";
    "editor.fontSize" = config.ui.fontSize;
    "editor.guides.bracketPairs" = "active";
    "editor.minimap.maxColumn" = 80;
    "editor.minimap.renderCharacters" = false;
    "editor.minimap.showSlider" = "always";
    "editor.minimap.side" = "left";
    "editor.minimap.size" = "fill";
    "editor.rulers" = [ 80 ];
    "editor.tabSize" = 2;
    "editor.wordWrap" = "on";
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "extensions.autoUpdate" = false;
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.trimTrailingWhitespace" = true;
    "python.analysis.autoSearchPaths" = false;
    "python.analysis.diagnosticMode" = "openFilesOnly";
    "python.formatting.provider" = "none";
    "python.languageServer" = "Pylance";
    "python.linting.enabled" = true;
    "python.linting.lintOnSave" = true;
    "python.linting.mypyArgs" = [
      "--config-file"
      "${makesSrc}/src/evaluator/modules/lint-python/settings-mypy.cfg"
    ];
    "python.linting.mypyEnabled" = true;
    "python.linting.mypyPath" =
      "${pythonOnNix.mypy-latest-python39-bin}/bin/mypy";
    "python.linting.prospectorArgs" = [
      "--profile"
      "${makesSrc}/src/evaluator/modules/lint-python/settings-prospector.yaml"
    ];
    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
    "python.linting.prospectorEnabled" = true;
    "python.linting.prospectorPath" =
      "${pythonOnNix.prospector-latest-python39-bin}/bin/prospector";
    "python.linting.pylintEnabled" = false;
    "python.pythonPath" = "${nixpkgs.python38}/bin/python";
    "security.workspace.trust.enabled" = false;
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "window.zoomLevel" = 4;
    "workbench.colorTheme" = "Default High Contrast";
    "workbench.editor.enablePreview" = false;
    "workbench.editor.focusRecentEditorAfterClose" = false;
    "workbench.editor.openPositioning" = "last";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
  };
in
{
  environment.variables.EDITOR = bin;
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "code" ''
      exec ${bin} "$@"
    '')
  ];
  home-manager.users.${config.wellKnown.username} = {
    programs.git.extraConfig = {
      core.editor = "${bin} --wait";
      diff.tool = "editor";
      difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
      merge.tool = "editor";
      mergetool.editor.cmd = "${bin} --wait $MERGED";
    };
  };
  system.userActivationScripts.vscode =
    let
      name = "editor-setup";
      script = makes.makeScript {
        inherit name;
        entrypoint = ./entrypoint.sh;
        replace = {
          __argBin__ = bin;
          __argExtensions__ = makes.toBashArray extensions;
          __argSettings__ = makes.toFileJson "settings.json" settings;
          __argUserDataDir__ = userDataDir;
        };
      };
    in
    builtins.readFile "${script}/bin/${name}";
}
