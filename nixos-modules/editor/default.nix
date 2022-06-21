{
  alejandra,
  config,
  fenix,
  makes,
  makesSrc,
  nixpkgs,
  pythonOnNix,
  ...
}: let
  extensionsDir = "/data/editor/extensions";
  userDataDir = "/data/editor/data";
  bin = builtins.concatStringsSep " " [
    "${nixpkgs.vscode}/bin/code" # unfree
    "--extensions-dir"
    extensionsDir
    "--user-data-dir"
    userDataDir
  ];
  extensions = nixpkgs.symlinkJoin {
    name = "extensions";
    paths = [
      fenix.rust-analyzer-vscode-extension
      nixpkgs.vscode-extensions._4ops.terraform
      nixpkgs.vscode-extensions.bbenoist.nix
      nixpkgs.vscode-extensions.coolbear.systemd-unit-file
      nixpkgs.vscode-extensions.daohong-emilio.yash
      nixpkgs.vscode-extensions.eamodio.gitlens
      # nixpkgs.vscode-extensions.grapecity.gc-excelviewer
      nixpkgs.vscode-extensions.hashicorp.terraform
      nixpkgs.vscode-extensions.haskell.haskell
      nixpkgs.vscode-extensions.jkillian.custom-local-formatters
      nixpkgs.vscode-extensions.justusadam.language-haskell
      nixpkgs.vscode-extensions.kamadorueda.alejandra
      nixpkgs.vscode-extensions.njpwerner.autodocstring
      nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
      nixpkgs.vscode-extensions.ms-python.python
      nixpkgs.vscode-extensions.ms-python.vscode-pylance # unfree
      nixpkgs.vscode-extensions.ms-toolsai.jupyter
      nixpkgs.vscode-extensions.ms-toolsai.jupyter-renderers
      nixpkgs.vscode-extensions.ms-vscode-remote.remote-ssh # unfree
      nixpkgs.vscode-extensions.redhat.java
      nixpkgs.vscode-extensions.shardulm94.trailing-spaces
      nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      nixpkgs.vscode-extensions.tamasfe.even-better-toml

      (nixpkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gc-excelviewer";
          publisher = "grapecity";
          version = "4.2.54";
          sha256 = "sha256-uMfCPk3ZwNCiHLVle7Slxw6n/FiIrlMR2T/jCggtK+s=";
        };
      })
    ];
  };
  settings = {
    "[python]"."editor.tabSize" = 4;
    "[rust]"."editor.tabSize" = 4;
    "alejandra.program" = "${alejandra}/bin/alejandra";
    "customLocalFormatters.formatters" = [
      {
        command = "${nixpkgs.clang-tools}/bin/clang-format --sort-includes";
        languages = ["cpp"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser css";
        languages = ["css"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser html";
        languages = ["html"];
      }
      {
        command = "${nixpkgs.google-java-format}/bin/google-java-format -";
        languages = ["java"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser babel";
        languages = ["javascript"];
      }
      {
        command = "${nixpkgs.jq}/bin/jq -S";
        languages = ["json" "jsonc"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser markdown";
        languages = ["markdown"];
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
          '')
          .outPath;
        languages = ["python"];
      }
      {
        command = "${fenix.latest.rustfmt}/bin/rustfmt --config-path ${./rustfmt.toml}";
        languages = ["rust"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser scss";
        languages = ["scss"];
      }
      {
        command = "${nixpkgs.shfmt}/bin/shfmt -bn -ci -i 2 -s -sr -";
        languages = ["shellscript"];
      }
      {
        command = "${nixpkgs.terraform}/bin/terraform fmt -";
        languages = ["terraform"];
      }
      {
        command =
          (nixpkgs.writeScript "toml-fmt" ''
            #! ${nixpkgs.bash}/bin/bash

            NODE_PATH=${nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH \
            ${nixpkgs.nodePackages.prettier}/bin/prettier \
              --parser toml \
              --plugin prettier-plugin-toml
          '')
          .outPath;
        languages = ["toml"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser yaml";
        languages = ["yaml"];
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
    "editor.fontFamily" = "monospace, emoji";
    "editor.fontLigatures" = true;
    "editor.fontSize" = config.ui.fontSize;
    "editor.guides.bracketPairs" = "active";
    "editor.minimap.enabled" = false;
    "editor.minimap.maxColumn" = 80;
    "editor.minimap.renderCharacters" = true;
    "editor.minimap.showSlider" = "always";
    "editor.minimap.side" = "left";
    "editor.minimap.size" = "fill";
    "editor.rulers" = [80];
    "editor.tabSize" = 2;
    "editor.wordWrap" = "off";
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "extensions.autoUpdate" = false;
    "files.eol" = "\n";
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;
    "files.trimTrailingWhitespace" = true;
    "gitlens.showWelcomeOnInstall" = false;
    "gitlens.showWhatsNewAfterUpgrades" = false;
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
    "security.workspace.trust.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "window.zoomLevel" = 3;
    "workbench.activityBar.visible" = false;
    "workbench.colorTheme" = "Default High Contrast";
    "workbench.editor.enablePreview" = false;
    "workbench.editor.focusRecentEditorAfterClose" = false;
    "workbench.editor.openPositioning" = "last";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
  };
in {
  environment.variables.EDITOR = bin;
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "editor" ''
      export PATH="${fenix.latest.toolchain}/bin:$PATH"
      exec ${bin} "$@"
    '')
  ];
  programs.git.config = {
    core.editor = "${bin} --wait";
    diff.tool = "editor";
    difftool.editor.cmd = "${bin} --diff $LOCAL $REMOTE --wait";
    merge.tool = "editor";
    mergetool.editor.cmd = "${bin} --wait $MERGED";
  };
  systemd.user.services."machine-editor-setup" = {
    description = "Machine's editor setup";
    script = ''
      ${nixpkgs.substitute {
        src = nixpkgs.writeScript "machine-editor-setup.sh" ''
          set -eux

          export PATH=${nixpkgs.lib.makeSearchPath "bin" [nixpkgs.coreutils]}

          rm -rf "@userDataDir@"
          rm -rf "@extensionsDir@"

          mkdir -p "@userDataDir@/User"
          mkdir -p "@extensionsDir@"

          cp --no-preserve=mode,ownership \
            "@settings@" "@userDataDir@/User/settings.json"
          cp --no-preserve=mode,ownership -rT \
            "@extensions@/share/vscode/extensions/" "@extensionsDir@"
        '';
        replacements = [
          ["--replace" "@extensions@" extensions]
          ["--replace" "@extensionsDir@" extensionsDir]
          ["--replace" "@settings@" (makes.toFileJson "settings.json" settings)]
          ["--replace" "@userDataDir@" userDataDir]
        ];
        isExecutable = true;
      }}
    '';
    serviceConfig.Type = "oneshot";
  };
}
