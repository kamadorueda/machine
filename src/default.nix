machine: rec {
  abs = {
    email = "kamadorueda@gmail.com";
    emailAtWork = "kamado@fluidattacks.com";
    font = "ProFont for Powerline";
    home = "/home/${abs.username}";
    locale = "en_US.UTF-8";
    name = "Kevin Amado";
    signingkey = "FFF341057F503148";
    username = "kamadorueda";
  };

  # NixOS: https://nixos.org/manual/nixos/stable/options.html
  # Home Manager: https://nix-community.github.io/home-manager/options.html
  config = {
    boot = {
      cleanTmpDir = true;
      loader = {
        efi = {
          canTouchEfiVariables = true;
        };
        grub = {
          useOSProber = true;
        };
        systemd-boot = {
          enable = true;
        };
      };
      tmpOnTmpfs = true;
    };
    fonts = {
      enableDefaultFonts = true;
      fonts = [
        packages.nixpkgs.powerline-fonts
      ];
      fontconfig = {
        enable = true;
      };
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users = {
        "${abs.username}" = {
          home = {
            activation = { };
            enableDebugInfo = true;
            file = {
              # Inpure Appimage backup just in case I need it
              timedoctor = {
                executable = true;
                source = sources.timedoctor;
                target = "timedoctor.AppImage";
              };
            };
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
              initExtra = builtins.readFile ../bashrc.sh;
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
                "\\~/Documents/github/kamadorueda/machine" = "@machine";
                "\\~/Documents/github/kamadorueda/secrets" = "@secrets";
                "\\~/Documents/gitlab/fluidattacks/product" = "@product";
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
                  identityFile = "~/.ssh/id_ed25519";
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
                packages.nixpkgs.vscode-extensions.eamodio.gitlens
                packages.nixpkgs.vscode-extensions.jkillian.custom-local-formatters
                packages.nixpkgs.vscode-extensions.haskell.haskell
                packages.nixpkgs.vscode-extensions.justusadam.language-haskell
                packages.nixpkgs.vscode-extensions.mads-hartmann.bash-ide-vscode
                packages.nixpkgs.vscode-extensions.ms-azuretools.vscode-docker
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
                "editor.formatOnSave" = true;
                "editor.fontFamily" = "'${abs.font}'";
                "editor.fontSize" = 18;
                "editor.minimap.maxColumn" = 80;
                "editor.minimap.renderCharacters" = false;
                "editor.minimap.showSlider" = "always";
                "editor.minimap.side" = "left";
                "editor.minimap.size" = "fill";
                "editor.rulers" = [ 80 ];
                "editor.tabSize" = 2;
                "editor.wordWrap" = "on";
                "extensions.autoUpdate" = false;
                "files.eol" = "\n";
                "files.insertFinalNewline" = true;
                "files.trimFinalNewlines" = true;
                "files.trimTrailingWhitespace" = true;
                "python.analysis.autoSearchPaths" = false;
                "python.analysis.diagnosticMode" = "workspace";
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
          targets = {
            genericLinux = {
              enable = true;
            };
          };
          xdg = {
            desktopEntries = {
              timedoctor = {
                name = "timedoctor";
                exec = "${machine.packages.timedoctor}/bin/timedoctor";
                terminal = false;
              };
            };
            mimeApps = {
              defaultApplications = {
                "application/xhtml+xml" = "google-chrome.desktop";
                "text/html" = "google-chrome.desktop";
                "x-scheme-handler/http" = "google-chrome.desktop";
                "x-scheme-handler/https" = "google-chrome.desktop";
              };
              enable = true;
            };
            enable = true;
          };
        };
      };
    };
    i18n = {
      defaultLocale = "en_US.UTF-8";
    };
    networking = {
      interfaces = {
        enp0s31f6 = { useDHCP = true; };
        wlp0s20f3 = { useDHCP = true; };
      };
      useDHCP = false;
    };
    nix = {
      gc = {
        automatic = true;
        dates = "00:00";
        persistent = true;
      };
      nixPath = [
        "nixos-config=${abs.home}/Documents/github/kamadorueda/machine/configuration.nix"
        "nixpkgs=${sources.nixpkgs}"
      ];
      optimise = {
        automatic = true;
        dates = [ "00:00" ];
      };
      readOnlyStore = true;
      trustedUsers = [
        "root"
      ];
      useSandbox = true;
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
      };
    };
    services = {
      xserver = {
        desktopManager = {
          gnome = {
            enable = true;
          };
        };
        displayManager = {
          gdm = {
            enable = true;
          };
        };
        enable = true;
        libinput = {
          enable = true;
        };
      };
    };
    system = {
      autoUpgrade = {
        enable = false;
      };
      stateVersion = "21.05";
    };
    time = {
      timeZone = "America/Bogota";
    };
    users = {
      mutableUsers = false;
      users = {
        root = {
          password = "";
        };
        "${abs.username}" = {
          extraGroups = [ "wheel" ];
          home = abs.home;
          isNormalUser = true;
          password = "";
        };
      };
    };
  };
  packages = {
    homeManager = utils.remoteImport {
      args = {
        pkgs = packages.nixpkgs;
      };
      source = sources.homeManager;
    };
    nixpkgs = utils.remoteImport {
      args = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          (self: super: {
            libjpeg8 = super.libjpeg.override {
              enableJpeg8 = true;
            };
          })
        ];
      };
      source = sources.nixpkgs;
    };
    product = utils.remoteImport {
      source = sources.product;
    };
    timedoctorExtracted = packages.nixpkgs.appimageTools.extract {
      name = "timedoctor-extracted";
      src = sources.timedoctor;
    };
  };
  sources = import ../nix/sources.nix;
  utils = {
    remoteImport = { args ? null, source }:
      if args == null
      then import source
      else import source args;
  };
}
