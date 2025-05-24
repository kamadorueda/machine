{
  config,
  pkgs,
}: let
  inherit (pkgs.lib.meta) getExe getExe';
in {
  "[python]"."editor.tabSize" = 4;
  "[rust]"."editor.tabSize" = 2;
  "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
  "alejandra.program" = getExe pkgs.alejandra;
  "customLocalFormatters.formatters" = [
    {
      command = "${getExe' pkgs.clang-tools "clang-format"} --sort-includes --style=file:${./clang.yaml}";
      languages = ["c" "cpp"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser css";
      languages = ["css"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser html";
      languages = ["html"];
    }
    {
      command = "${getExe pkgs.google-java-format} -";
      languages = ["java"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser babel";
      languages = ["javascript"];
    }
    {
      command = "${getExe pkgs.jq} -S";
      languages = ["json" "jsonc"];
    }
    {
      command = getExe' pkgs.texlive.combined.scheme-medium "latexindent";
      languages = ["latex"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser markdown";
      languages = ["markdown"];
    }
    {
      command = getExe (pkgs.writeShellApplication {
        name = "python-fmt";
        runtimeInputs = [pkgs.black pkgs.isort];
        text = ''
          black --config ${./black.toml} - \
            | isort --settings-path ${./isort.toml} -
        '';
      });
      languages = ["python"];
    }
    {
      command = getExe' pkgs.fenix.latest.rustfmt "rust-fmt";
      languages = ["rust"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser scss";
      languages = ["scss"];
    }
    {
      command = "${getExe pkgs.shfmt} -bn -ci -i 2 -s -sr -";
      languages = ["shellscript"];
    }
    {
      command = getExe pkgs.nodePackages.sql-formatter;
      languages = ["sql"];
    }
    {
      command = "${getExe pkgs.terraform} fmt -";
      languages = ["tf"];
    }
    # {
    #   command =
    #     (pkgs.writeShellScript "toml-fmt" ''
    #       NODE_PATH=${pkgs.nodePackages.prettier-plugin-toml}/lib/node_modules \
    #       ${pkgs.nodePackages.prettier}/bin/prettier \
    #         --parser toml \
    #         --plugin prettier-plugin-toml
    #     '')
    #     .outPath;
    #   languages = ["toml"];
    # }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser html";
      languages = ["xml"];
    }
    {
      command = "${getExe pkgs.nodePackages.prettier} --parser yaml";
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
  "python.linting.mypyPath" = getExe pkgs.mypy;
  # "python.linting.prospectorArgs" = ["--profile" ./prospector.yaml];
  # "python.linting.prospectorEnabled" = true;
  # "python.linting.prospectorPath" = getExe pkgs.prospector";
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
