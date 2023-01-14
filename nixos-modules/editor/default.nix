{
  config,
  fenix,
  nixpkgs,
  ...
}: let
  pkg = nixpkgs.vscode;

  extensionsDir = "/data/editor/extensions";
  userDataDir = "/data/editor/data";

  bin = builtins.concatStringsSep " " [
    "${pkg}/bin/code" # unfree
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
      nixpkgs.vscode-extensions.bierner.markdown-mermaid
      nixpkgs.vscode-extensions.coolbear.systemd-unit-file
      nixpkgs.vscode-extensions.daohong-emilio.yash
      nixpkgs.vscode-extensions.eamodio.gitlens
      nixpkgs.vscode-extensions.grapecity.gc-excelviewer
      nixpkgs.vscode-extensions.hashicorp.terraform
      nixpkgs.vscode-extensions.haskell.haskell
      nixpkgs.vscode-extensions.jkillian.custom-local-formatters
      nixpkgs.vscode-extensions.justusadam.language-haskell
      nixpkgs.vscode-extensions.kamadorueda.alejandra
      nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
      nixpkgs.vscode-extensions.mattn.lisp
      nixpkgs.vscode-extensions.mkhl.direnv
      nixpkgs.vscode-extensions.ms-python.python
      nixpkgs.vscode-extensions.ms-python.vscode-pylance # unfree
      nixpkgs.vscode-extensions.ms-toolsai.jupyter
      nixpkgs.vscode-extensions.ms-toolsai.jupyter-renderers
      nixpkgs.vscode-extensions.ms-vscode.cpptools
      # nixpkgs.vscode-extensions.ms-vscode-remote.remote-ssh # unfree
      nixpkgs.vscode-extensions.njpwerner.autodocstring
      nixpkgs.vscode-extensions.redhat.java
      nixpkgs.vscode-extensions.shardulm94.trailing-spaces
      nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      nixpkgs.vscode-extensions.tamasfe.even-better-toml
      nixpkgs.vscode-extensions.tomoki1207.pdf
      nixpkgs.vscode-extensions.usernamehw.errorlens
    ];
  };

  settings = {
    "[python]"."editor.tabSize" = 4;
    "[rust]"."editor.tabSize" = 4;
    "alejandra.program" = "${nixpkgs.alejandra}/bin/alejandra";
    "customLocalFormatters.formatters" = [
      {
        command = "${nixpkgs.clang-tools}/bin/clang-format --sort-includes --style=file:${./clang.yaml}";
        languages = ["c" "cpp"];
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
        command = "${nixpkgs.texlive.combined.scheme-medium}/bin/latexindent";
        languages = ["latex"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser markdown";
        languages = ["markdown"];
      }
      {
        command =
          (nixpkgs.writeShellScript "python-fmt" ''
            ${nixpkgs.black}/bin/black --config ${./black.toml} - \
            | ${nixpkgs.isort}/bin/isort --settings-path ${./isort.toml} -
          '')
          .outPath;
        languages = ["python"];
      }
      {
        command = "${fenix.latest.rustfmt}/bin/rustfmt";
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
        command = "${nixpkgs.nodePackages.sql-formatter}/bin/sql-formatter";
        languages = ["sql"];
      }
      {
        command = "${nixpkgs.terraform}/bin/terraform fmt -";
        languages = ["terraform"];
      }
      {
        command =
          (nixpkgs.writeShellScript "toml-fmt" ''
            NODE_PATH=${nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules \
            ${nixpkgs.nodePackages.prettier}/bin/prettier \
              --parser toml \
              --plugin prettier-plugin-toml
          '')
          .outPath;
        languages = ["toml"];
      }
      {
        command = "${nixpkgs.nodePackages.prettier}/bin/prettier --parser html";
        languages = ["xml"];
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
    "editor.formatOnType" = true;
    "editor.fontFamily" = "monospace";
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
    "python.linting.mypyArgs" = ["--config-file" ./mypy.toml];
    "python.linting.mypyEnabled" = true;
    "python.linting.mypyPath" = "${nixpkgs.mypy}/bin/mypy";
    "python.linting.prospectorArgs" = ["--profile" ./prospector.yaml];
    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
    "python.linting.prospectorEnabled" = true;
    "python.linting.prospectorPath" = "${nixpkgs.prospector}/bin/prospector";
    "python.linting.pylintEnabled" = false;
    "rust-analyzer.imports.prefer.no.std" = false;
    "rust-analyzer.imports.prefix" = "crate";
    "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
    "rust-analyzer.inlayHints.closingBraceHints.minLines" = 0;
    "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "always";
    "rust-analyzer.inlayHints.expressionAdjustmentHints.enable" = "always";
    "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "always";
    "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
    "rust-analyzer.inlayHints.maxLength" = null;
    "rust-analyzer.lens.references.adt.enable" = true;
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

  settingsJson =
    nixpkgs.runCommand "settings.json" {
      passAsFile = ["settings"];
      settings = builtins.toJSON settings;
    }
    "cp $settingsPath $out";
in {
  environment.variables.EDITOR = "${bin} --wait";
  environment.systemPackages = [
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
    description = "Machine's editor setup";
    script = ''
      ${nixpkgs.substitute {
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
      }}
    '';
    serviceConfig = {
      Group = config.users.users.${config.wellKnown.username}.group;
      Type = "oneshot";
      User = config.wellKnown.username;
    };
  };
}
