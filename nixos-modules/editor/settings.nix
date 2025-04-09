{
  config,
  nixpkgs,
}: {
  "[python]"."editor.tabSize" = 4;
  "[rust]"."editor.tabSize" = 2;
  "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
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
      command = "${nixpkgs.fenix.latest.rustfmt}/bin/rustfmt";
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
      languages = ["tf"];
    }
    # {
    #   command =
    #     (nixpkgs.writeShellScript "toml-fmt" ''
    #       NODE_PATH=${nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules \
    #       ${nixpkgs.nodePackages.prettier}/bin/prettier \
    #         --parser toml \
    #         --plugin prettier-plugin-toml
    #     '')
    #     .outPath;
    #   languages = ["toml"];
    # }
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
  "editor.wrappingIndent" = "deepIndent";
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
  "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
  "python.formatting.provider" = "none";
  "python.languageServer" = "Pylance";
  "python.linting.enabled" = true;
  "python.linting.lintOnSave" = true;
  "python.linting.mypyArgs" = ["--config-file" ./mypy.toml];
  "python.linting.mypyEnabled" = true;
  "python.linting.mypyPath" = "${nixpkgs.mypy}/bin/mypy";
  # "python.linting.prospectorArgs" = ["--profile" ./prospector.yaml];
  # "python.linting.prospectorEnabled" = true;
  # "python.linting.prospectorPath" = "${nixpkgs.prospector}/bin/prospector";
  "python.linting.pylintEnabled" = false;
  "rust-analyzer.assist.emitMustUse" = true;
  "rust-analyzer.cargo.buildScripts.useRustcWrapper" = false;
  "rust-analyzer.cargo.features" = "all";
  "rust-analyzer.check.allTargets" = true;
  "rust-analyzer.hover.actions.references.enable" = true;
  "rust-analyzer.imports.prefer.no.std" = false;
  "rust-analyzer.imports.prefix" = "crate";
  "rust-analyzer.inlayHints.bindingModeHints.enable" = true;
  "rust-analyzer.inlayHints.closingBraceHints.minLines" = 0;
  "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "always";
  "rust-analyzer.inlayHints.discriminantHints.enable" = "always";
  "rust-analyzer.inlayHints.expressionAdjustmentHints.enable" = "always";
  "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "always";
  "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
  "rust-analyzer.inlayHints.maxLength" = null;
  "rust-analyzer.lens.location" = "above_whole_item";
  "rust-analyzer.lens.references.adt.enable" = true;
  "rust-analyzer.lens.references.enumVariant.enable" = true;
  "rust-analyzer.lens.references.method.enable" = true;
  "rust-analyzer.lens.references.trait.enable" = true;
  "rust-analyzer.lru.capacity" = 1024;
  "rust-analyzer.restartServerOnConfigChange" = true;
  "rust-analyzer.semanticHighlighting.operator.specialization.enable" = true;
  "rust-analyzer.semanticHighlighting.punctuation.enable" = true;
  "rust-analyzer.semanticHighlighting.punctuation.separate.macro.bang" = true;
  "rust-analyzer.semanticHighlighting.punctuation.specialization.enable" = true;
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
}
