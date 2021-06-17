_: with _;{
  "${abs.username}" = { lib, ... }: {
    dconf = {
      settings = with lib.hm.gvariant; {
        "org/gnome/desktop/a11y" = {
          always-show-universal-access-status = true;
        };
        "org/gnome/desktop/a11y/applications" = {
          screen-magnifier-enabled = false;
        };
        "org/gnome/desktop/a11y/magnifier" = {
          lens-mode = true;
          mag-factor = 1.5;
          mouse-tracking = "proportional";
          screen-position = "full-screen";
          scroll-at-edges = false;
        };
        "org/gnome/desktop/input-sources" = {
          current = mkUint32 0;
          per-window = false;
          sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) ];
          xkb-options = [
            "terminate:ctrl_alt_bksp"
            "lv3:ralt_switch"
          ];
        };
        "org/gnome/desktop/interface" = {
          gtk-im-module = "ibus";
          gtk-theme = "HighContrast";
          icon-theme = "HighContrast";
          show-battery-percentage = true;
          text-scaling-factor = 1.0;
        };
        "org/gnome/desktop/peripherals/mouse" = {
          natural-scroll = false;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
          two-finger-scrolling-enabled = true;
        };
        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 0;
        };
        "org/gnome/desktop/wm/preferences" = {
          theme = "HighContrast";
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-schedule-from = 12.0;
          night-light-schedule-to = 11.99;
          night-light-temperature = mkUint32 3700; # 1700 (warm) to 4700 (cold)
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
          help = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Primary><Alt>t";
          command = "gnome-terminal";
          name = "gnome-terminal";
        };
        "org/gnome/settings-daemon/plugins/power" = {
          idle-dim = false;
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
      };
    };
    home = {
      enableDebugInfo = true;
      homeDirectory = abs.home;
      language = {
        address = abs.locale;
        base = abs.locale;
        collate = abs.locale;
        ctype = abs.locale;
        name = abs.locale;
        numeric = abs.locale;
        measurement = abs.locale;
        messages = abs.locale;
        monetary = abs.locale;
        paper = abs.locale;
        telephone = abs.locale;
        time = abs.locale;
      };
      stateVersion = "21.05";
      username = abs.username;
    };
    programs = {
      bash = {
        enable = true;
        initExtra = ''
          test -f /etc/bashrc && source /etc/bashrc
        '';
      };
      bat = {
        enable = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
      };
      git = {
        enable = true;
        extraConfig = {
          commit = {
            gpgsign = true;
          };
          core = {
            editor = "${packages.nixpkgs.vscode}/bin/code --wait";
          };
          diff = {
            sopsdiffer = {
              textconv =
                (packages.nixpkgs.writeScript "sopsdiffer.sh" ''
                  #! ${packages.nixpkgs.bash}/bin/bash
                  sops -d "$1" || cat "$1"
                '').outPath;
            };
            tool = "vscode";
          };
          difftool = {
            vscode = {
              cmd = "${packages.nixpkgs.vscode}/bin/code --diff $LOCAL $REMOTE --wait";
            };
          };
          init = {
            defaultbranch = "main";
          };
          gpg = {
            progam = "${packages.nixpkgs.gnupg}/bin/gpg2";
            sign = true;
          };
          init = {
            defaultBranch = "main";
          };
          merge = {
            tool = "vscode";
          };
          mergetool = {
            vscode = {
              cmd = "${packages.nixpkgs.vscode}/bin/code --wait $MERGED";
            };
          };
          user = {
            email = abs.email;
            name = abs.name;
            signingkey = abs.signingkey;
          };
        };
        package = packages.nixpkgs.git;
      };
      gnome-terminal = {
        enable = true;
        profile = {
          "e0b782ed-6aca-44eb-8c75-62b3706b6220" = {
            allowBold = true;
            audibleBell = true;
            backspaceBinding = "ascii-delete";
            boldIsBright = true;
            colors = {
              backgroundColor = "#000000";
              foregroundColor = "#FFFFFF";
              palette = [
                "#000000"
                "#CD0000"
                "#00CD00"
                "#CDCD00"
                "#0000EE"
                "#CD00CD"
                "#00CDCD"
                "#E5E5E5"
                "#7F7F7F"
                "#FF0000"
                "#00FF00"
                "#FFFF00"
                "#5C5CFF"
                "#FF00FF"
                "#00FFFF"
                "#FFFFFF"
              ];
            };
            cursorBlinkMode = "off";
            cursorShape = "underline";
            default = true;
            deleteBinding = "delete-sequence";
            font = "${abs.font} 26";
            scrollbackLines = 1000000;
            scrollOnOutput = false;
            showScrollbar = false;
            transparencyPercent = 4;
            visibleName = abs.username;
          };
        };
        showMenubar = false;
        themeVariant = "dark";
      };
      gpg = {
        enable = true;
        package = packages.nixpkgs.gnupg;
      };
      jq = {
        enable = true;
      };
      powerline-go = {
        enable = true;
        modules = [ "cwd" "exit" "git" "time" ];
        newline = true;
        pathAliases = {
          "${abs.machine}" = "@machine";
          "${abs.product}" = "@product";
          "${abs.secrets}" = "@secrets";
        };
        settings = {
          cwd-max-depth = "3";
          cwd-max-dir-size = "16";
          git-mode = "fancy";
          numeric-exit-codes = true;
          shell = "bash";
          theme = "default";
        };
      };
      ssh = {
        enable = true;
        matchBlocks = {
          "gitlab.com" = {
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
            identityFile = "${abs.home}/.ssh/${abs.username}";
          };
        };
      };
      vim = {
        enable = true;
        extraConfig = "";
        plugins = [ ];
        settings = {
          background = "dark";
          mouse = "a";
        };
      };
      vscode = {
        enable = true;
        extensions = [
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
        keybindings = [
        ];
        package = packages.nixpkgs.vscode;
        userSettings = {
          "[html]" = { "editor.formatOnSave" = false; };
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
    xdg = {
      desktopEntries = {
        timedoctor = {
          name = "timedoctor";
          exec = "${packages.timedoctor}/bin/timedoctor";
          terminal = false;
        };
      };
      enable = true;
    };
  };
}
