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
          mag-factor = 2.0;
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
          cursor-size = 48;
          gtk-im-module = "ibus";
          gtk-theme = "HighContrast";
          icon-theme = "HighContrast";
          show-battery-percentage = true;
          text-scaling-factor = 1.5;
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
        "org/gnome/desktop/sound" = {
          allow-volume-above-100-percent = true;
        };
        "org/gnome/desktop/wm/preferences" = {
          theme = "HighContrast";
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = false;
          night-light-schedule-automatic = false;
          night-light-schedule-from = 12.0;
          night-light-schedule-to = 11.99;
          night-light-temperature = mkUint32 3700; # 1700 (warm) to 4700 (cold)
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/"
          ];
          help = [ ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Primary><Super>t";
          command = "gnome-terminal";
          name = "gnome-terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Primary><Super>w";
          command = "xdotool mousemove_relative -- 0 -10";
          name = "mouse-up";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Primary><Super>s";
          command = "xdotool mousemove_relative -- 0 10";
          name = "mouse-down";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          binding = "<Primary><Super>a";
          command = "xdotool mousemove_relative -- -10 0";
          name = "mouse-left";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          binding = "<Primary><Super>d";
          command = "xdotool mousemove_relative -- 10 0";
          name = "mouse-right";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
          binding = "<Primary><Super>q";
          command = "xdotool click --clearmodifiers 1";
          name = "mouse-click-left";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
          binding = "<Primary><Super>e";
          command = "xdotool click --clearmodifiers 3";
          name = "mouse-click-right";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7" = {
          binding = "<Primary><Super>r";
          command = "xdotool click --clearmodifiers 4";
          name = "mouse-scroll-up";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8" = {
          binding = "<Primary><Super>f";
          command = "xdotool click --clearmodifiers 5";
          name = "mouse-scroll-down";
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
            editor = "${abs.editor.bin} --wait";
          };
          diff = {
            renamelimit = 16384;
            sopsdiffer = {
              textconv =
                (inputs.nixpkgs.writeScript "sopsdiffer.sh" ''
                  #! ${inputs.nixpkgs.bash}/bin/bash
                  sops -d "$1" || cat "$1"
                '').outPath;
            };
            tool = "vscode";
          };
          difftool = {
            vscode = {
              cmd = "${abs.editor.bin} --diff $LOCAL $REMOTE --wait";
            };
          };
          init = {
            defaultbranch = "main";
          };
          gpg = {
            progam = "${inputs.nixpkgs.gnupg}/bin/gpg2";
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
              cmd = "${abs.editor.bin} --wait $MERGED";
            };
          };
          user = {
            email = abs.email;
            name = abs.name;
            signingkey = abs.signingkey;
          };
        };
        package = inputs.nixpkgs.git;
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
            font = "${abs.font} 23";
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
      powerline-go = {
        enable = true;
        modules = [ "cwd" "exit" "git" "time" ];
        newline = true;
        pathAliases = {
          "${abs.machine}" = "@machine";
          "${abs.makes}" = "@makes";
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
          "github.com" = {
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
            identityFile = "${abs.secrets}/machine/ssh/kamadorueda";
          };
          "gitlab.com" = {
            extraOptions = {
              PreferredAuthentications = "publickey";
            };
            identityFile = "${abs.secrets}/machine/ssh/kamadorueda";
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
    };
    xdg = {
      desktopEntries = {
        timedoctorNix = with inputs.nixpkgsTimedoctor; {
          name = "timedoctor-nix";
          exec = "${timedoctor}/bin/${timedoctor.name}";
          terminal = false;
        };
      };
      enable = true;
    };
  };
}
