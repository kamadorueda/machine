_: with _;
let
  name = "config-system-user-activation-scripts-vscode";

  script = packages.makes.makeScript {
    inherit name;
    entrypoint = ./entrypoint.sh;
    replace = {
      __argEditor__ = abs.editor.bin;
      __argSettings__ = packages.makes.toFileJson "settings.json" {
        "[html]" = {
          "editor.formatOnSave" = false;
        };
        "[python]" = { "editor.tabSize" = 4; };
        "customLocalFormatters.formatters" = [
          {
            command = "clang-format --sort-includes --style=microsoft";
            languages = [ "cpp" ];
          }
          {
            command = "jq -S";
            languages = [ "json" "jsonc" ];
          }
          {
            command = "${packages.nixpkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            languages = [ "nix" ];
          }
          {
            command =
              (packages.nixpkgs.writeScript "python-fmt" ''
                #! ${packages.nixpkgs.bash}/bin/bash

                ${packages.pythonOnNix.projects.black.latest.pythonLatest.bin}/bin/black \
                  --config \
                  ${sources.makes}/src/evaluator/modules/format-python/settings-black.toml \
                  - \
                  | \
                ${packages.pythonOnNix.projects.isort.latest.pythonLatest.bin}/bin/isort \
                  --settings-path \
                  ${sources.makes}/src/evaluator/modules/format-python/settings-isort.toml \
                  -
              '').outPath;
            languages = [ "python" ];
          }
          {
            command = "${packages.nixpkgs.shfmt}/bin/shfmt -bn -ci -i 2 -s -sr -";
            languages = [ "shellscript" ];
          }
          {
            command = "${packages.nixpkgs.terraform}/bin/terraform fmt -";
            languages = [ "terraform" ];
          }
        ];
        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.maxComputationTime" = 0;
        "diffEditor.renderSideBySide" = false;
        "diffEditor.wordWrap" = "on";
        "editor.cursorStyle" = "underline";
        "editor.defaultFormatter" = "jkillian.custom-local-formatters";
        "editor.formatOnPaste" = false;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
        "editor.fontFamily" = "'${abs.font}'";
        "editor.fontSize" = 16.5;
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
          "${sources.makes}/src/evaluator/modules/lint-python/settings-mypy.cfg"
        ];
        "python.linting.mypyEnabled" = true;
        "python.linting.mypyPath" =
          "${packages.pythonOnNix.projects.mypy.latest.pythonLatest.bin}/bin/mypy";
        "python.linting.prospectorArgs" = [
          "--profile"
          "${sources.makes}/src/evaluator/modules/lint-python/settings-prospector.yaml"
        ];
        "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
        "python.linting.prospectorEnabled" = true;
        "python.linting.prospectorPath" =
          "${packages.pythonOnNix.projects.prospector.latest.pythonLatest.bin}/bin/prospector";
        "python.linting.pylintEnabled" = false;
        "python.pythonPath" = "${packages.nixpkgs.python38}/bin/python";
        "security.workspace.trust.enabled" = false;
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
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
    };
  };
in
builtins.readFile "${script}/bin/${name}"
