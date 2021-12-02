_: with _;
let
  name = "config-system-user-activation-scripts-vscode";

  script = inputs.makes.makeScript {
    inherit name;
    entrypoint = ./entrypoint.sh;
    replace = {
      __argEditor__ = abs.editor.bin;
      __argSettings__ = inputs.makes.toFileJson "settings.json" {
        "[html]" = {
          "editor.formatOnSave" = false;
        };
        "[python]" = {
          "editor.tabSize" = 4;
        };
        "[rust]" = {
          "editor.tabSize" = 4;
        };
        "customLocalFormatters.formatters" = [
          {
            command = "clang-format --sort-includes --style=microsoft";
            languages = [ "cpp" ];
          }
          {
            command = "${inputs.nixpkgs.jq}/bin/jq -S";
            languages = [ "json" "jsonc" ];
          }
          {
            command = "${inputs.nixpkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            languages = [ "nix" ];
          }
          {
            command =
              (inputs.nixpkgs.writeScript "python-fmt" ''
                #! ${inputs.nixpkgs.bash}/bin/bash

                ${inputs.pythonOnNix.black-latest-python39-bin}/bin/black \
                  --config \
                  ${inputs.makesSrc}/src/evaluator/modules/format-python/settings-black.toml \
                  - \
                  | \
                ${inputs.pythonOnNix.isort-latest-python39-bin}/bin/isort \
                  --settings-path \
                  ${inputs.makesSrc}/src/evaluator/modules/format-python/settings-isort.toml \
                  -
              '').outPath;
            languages = [ "python" ];
          }
          {
            command = "${inputs.nixpkgs.rustfmt}/bin/rustfmt";
            languages = [ "rust" ];
          }
          {
            command = "${inputs.nixpkgs.shfmt}/bin/shfmt -bn -ci -i 2 -s -sr -";
            languages = [ "shellscript" ];
          }
          {
            command = "${inputs.nixpkgs.terraform}/bin/terraform fmt -";
            languages = [ "terraform" ];
          }
          {
            command =
              (inputs.nixpkgs.writeScript "python-fmt" ''
                #! ${inputs.nixpkgs.bash}/bin/bash

                ${inputs.nixpkgs.yj}/bin/yj -tj \
                  | ${inputs.nixpkgs.jq}/bin/jq -S \
                  | ${inputs.nixpkgs.yj}/bin/yj -jti
              '').outPath;
            languages = [ "toml" ];
          }
          {
            command = "${inputs.nixpkgs.html-tidy}/bin/tidy -xml -i -wrap 80";
            languages = [ "xml" ];
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
          "${inputs.makesSrc}/src/evaluator/modules/lint-python/settings-mypy.cfg"
        ];
        "python.linting.mypyEnabled" = true;
        "python.linting.mypyPath" =
          "${inputs.pythonOnNix.mypy-latest-python39-bin}/bin/mypy";
        "python.linting.prospectorArgs" = [
          "--profile"
          "${inputs.makesSrc}/src/evaluator/modules/lint-python/settings-prospector.yaml"
        ];
        "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
        "python.linting.prospectorEnabled" = true;
        "python.linting.prospectorPath" =
          "${inputs.pythonOnNix.prospector-latest-python39-bin}/bin/prospector";
        "python.linting.pylintEnabled" = false;
        "python.pythonPath" = "${inputs.nixpkgs.python38}/bin/python";
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
