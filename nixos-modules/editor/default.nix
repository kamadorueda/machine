{ alejandra
, config
, fenix
, lib
, makes
, makesSrc
, nixpkgs
, pythonOnNix
, ...
}:
let
  extensionsDir = "/data/vscode/extensions";
  userDataDir = "/data/vscode/data";
  bin = builtins.concatStringsSep " " [
    "${nixpkgs.vscode}/bin/code"
    "--extensions-dir"
    extensionsDir
    "--user-data-dir"
    userDataDir
  ];
  extensions = [
    fenix.rust-analyzer-vscode-extension
    nixpkgs.vscode-extensions._4ops.terraform
    nixpkgs.vscode-extensions.bbenoist.nix
    nixpkgs.vscode-extensions.coolbear.systemd-unit-file
    nixpkgs.vscode-extensions.eamodio.gitlens
    nixpkgs.vscode-extensions.hashicorp.terraform
    nixpkgs.vscode-extensions.haskell.haskell
    nixpkgs.vscode-extensions.jkillian.custom-local-formatters
    nixpkgs.vscode-extensions.justusadam.language-haskell
    nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
    nixpkgs.vscode-extensions.ms-python.python
    nixpkgs.vscode-extensions.ms-python.vscode-pylance
    nixpkgs.vscode-extensions.ms-toolsai.jupyter
    nixpkgs.vscode-extensions.ms-toolsai.jupyter-renderers
    nixpkgs.vscode-extensions.ms-vscode-remote.remote-ssh
    nixpkgs.vscode-extensions.shardulm94.trailing-spaces
    nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
    nixpkgs.vscode-extensions.tamasfe.even-better-toml
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
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser css";
        languages = [ "css" ];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser html";
        languages = [ "html" ];
      }
      {
        command = "${nixpkgs.jq}/bin/jq -S";
        languages = [ "json" "jsonc" ];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser markdown";
        languages = [ "markdown" ];
      }
      {
        command = alejandra.outputs.defaultApp.${nixpkgs.system}.program;
        languages = [ "nix" ];
      }
      {
        command =
          (
            nixpkgs.writeScript "python-fmt" ''
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
            ''
          )
          .outPath;
        languages = [ "python" ];
      }
      {
        command = "${fenix.latest.rustfmt}/bin/rustfmt --config-path ${./rustfmt.toml}";
        languages = [ "rust" ];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser scss";
        languages = [ "scss" ];
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
          (
            nixpkgs.writeScript "toml-fmt" ''
              #! ${nixpkgs.bash}/bin/bash

              NODE_PATH=${nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH \
              ${nixpkgs.nodePackages.prettier}/bin/prettier \
                --parser toml \
                --plugin prettier-plugin-toml
            ''
          )
          .outPath;
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
    "editor.fontFamily" = config.ui.font;
    "editor.fontLigatures" = false;
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
    "python.linting.mypyPath" = "${pythonOnNix.mypy-latest-python39-bin}/bin/mypy";
    "python.linting.prospectorArgs" = [
      "--profile"
      "${makesSrc}/src/evaluator/modules/lint-python/settings-prospector.yaml"
    ];
    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
    "python.linting.prospectorEnabled" = true;
    "python.linting.prospectorPath" = "${pythonOnNix.prospector-latest-python39-bin}/bin/prospector";
    "python.linting.pylintEnabled" = false;
    "python.pythonPath" = "${nixpkgs.python38}/bin/python";
    "security.workspace.trust.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "window.zoomLevel" = 2;
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
    fenix.stable.cargo
    fenix.stable.rustc
    fenix.stable.rust-src
    (
      nixpkgs.writeShellScriptBin "code" ''
        exec ${bin} "$@"
      ''
    )
  ];
  home-manager.users.${config.wellKnown.username} =
    { lib
    , ...
    }:
    {
      home.activation.editorSetup =
        let
          name = "editor-setup";
          script = makes.makeScript {
            inherit name;
            entrypoint = ./entrypoint.sh;
            replace = {
              __argExtensions__ = makes.toBashArray extensions;
              __argExtensionsDir__ = extensionsDir;
              __argSettings__ = makes.toFileJson "settings.json" settings;
              __argUserDataDir__ = userDataDir;
            };
          };
        in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ${script}/bin/${name}
          '';
      programs.git.extraConfig = {
        core.editor = "${bin} --wait";
        diff.tool = "editor";
        difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
        merge.tool = "editor";
        mergetool.editor.cmd = "${bin} --wait $MERGED";
      };
    };
}
