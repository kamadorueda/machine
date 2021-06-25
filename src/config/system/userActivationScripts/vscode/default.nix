_: with _; utils.script {
  env = {
    argExtensions = packages.nixpkgs.symlinkJoin {
      name = "extensions";
      paths = [
        packages.nixpkgs.vscode-extensions._4ops.terraform
        packages.nixpkgs.vscode-extensions.bbenoist.Nix
        packages.nixpkgs.vscode-extensions.coenraads.bracket-pair-colorizer-2
        packages.nixpkgs.vscode-extensions.coolbear.systemd-unit-file
        packages.nixpkgs.vscode-extensions.eamodio.gitlens
        packages.nixpkgs.vscode-extensions.jkillian.custom-local-formatters
        packages.nixpkgs.vscode-extensions.haskell.haskell
        packages.nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
        packages.nixpkgs.vscode-extensions.ms-python.python
        packages.nixpkgs.vscode-extensions.ms-python.vscode-pylance
        packages.nixpkgs.vscode-extensions.shardulm94.trailing-spaces
        packages.nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
        packages.nixpkgs.vscode-extensions.tamasfe.even-better-toml
      ];
    };
    argSettings = builtins.toJSON {
      "[html]" = {
        "editor.formatOnSave" = false;
      };
      "[python]" = { "editor.tabSize" = 4; };
      "customLocalFormatters.formatters" = [
        {
          command = "${packages.nixpkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          languages = [ "nix" ];
        }
        {
          command =
            (packages.nixpkgs.writeScript "python-fmt" ''
              #! ${packages.nixpkgs.bash}/bin/bash

              PYTHONPATH=/pythonpath/not/set

              ${packages.nixpkgs.black}/bin/black \
                --config \
                ${sources.product}/makes/utils/python-format/settings-black.toml \
                - \
                | \
              ${packages.nixpkgs.python38Packages.isort}/bin/isort \
                --settings-path \
                ${sources.product}/makes/utils/python-format/settings-isort.toml \
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
          languages = [ "tf" ];
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
      "editor.fontSize" = 18.4;
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
        "${sources.product}/makes/utils/lint-python/settings-mypy.cfg"
      ];
      "python.linting.mypyEnabled" = true;
      "python.linting.mypyPath" = "${packages.nixpkgs.mypy}/bin/mypy";
      "python.linting.prospectorArgs" = [
        "--profile"
        "${sources.product}/makes/utils/lint-python/settings-prospector.yaml"
      ];
      "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python3.8";
      "python.linting.prospectorEnabled" = true;
      "python.linting.prospectorPath" = "prospector";
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
  src = ./activate.sh;
}
