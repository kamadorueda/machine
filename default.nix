rec {
  abs = {
    email = "kamadorueda@gmail.com";
    emailAtWork = "kamado@fluidattacks.com";
    font = "ProFont for Powerline";
    home = "/home/kamado";
    locale = "en_US.UTF-8";
    name = "Kevin Amado";
    signingkey = "FFF341057F503148";
    username = "kamadorueda";
  };

  # Home manager configuration:
  # https://nix-community.github.io/home-manager/options.html
  config = {
    fonts = {
      fontconfig = {
        enable = true;
      };
    };
    home = {
      activation = { };
      enableDebugInfo = true;
      file = {
        # Inpure Appimage backup just in case I need it
        # timedoctor = {
        #   executable = true;
        #   source = sources.timedoctor.appimage;
        #   target = "timedoctor.AppImage";
        # };
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
      packages = [
        packages.nixpkgs.acpi
        packages.nixpkgs.age
        packages.nixpkgs.awscli
        packages.nixpkgs.beep
        packages.nixpkgs.bind
        packages.nixpkgs.binutils
        packages.nixpkgs.black
        packages.nixpkgs.burpsuite
        packages.nixpkgs.cabal-install
        packages.nixpkgs.cargo
        packages.nixpkgs.coreutils
        packages.nixpkgs.curl
        packages.nixpkgs.diction
        packages.nixpkgs.diffoscope
        packages.nixpkgs.evtest
        packages.nixpkgs.gcc
        packages.nixpkgs.ghc
        packages.nixpkgs.gimp
        packages.nixpkgs.git-sizer
        packages.nixpkgs.gnumake
        packages.nixpkgs.google-chrome
        packages.nixpkgs.gptfdisk
        packages.nixpkgs.hugo
        packages.nixpkgs.inxi
        packages.nixpkgs.kubectl
        packages.nixpkgs.libreoffice
        packages.nixpkgs.lshw
        packages.nixpkgs.lsof
        packages.nixpkgs.maven
        packages.nixpkgs.mypy
        packages.nixpkgs.ngrok
        packages.nixpkgs.nix-bundle
        packages.nixpkgs.nix-index
        packages.nixpkgs.nixops
        packages.nixpkgs.nixpkgs-fmt
        packages.nixpkgs.nixpkgs-review
        packages.nixpkgs.nodejs
        packages.nixpkgs.nodePackages.asar
        packages.nixpkgs.openjdk
        packages.nixpkgs.optipng
        packages.nixpkgs.parallel
        packages.nixpkgs.parted
        packages.nixpkgs.patchelf
        packages.nixpkgs.pciutils
        packages.nixpkgs.pcre
        packages.nixpkgs.peek
        packages.nixpkgs.powerline-fonts
        packages.nixpkgs.python38
        packages.nixpkgs.python38Packages.isort
        packages.nixpkgs.qemu
        packages.nixpkgs.shadow
        packages.nixpkgs.shfmt
        packages.nixpkgs.sops
        packages.nixpkgs.terraform
        packages.nixpkgs.tokei
        packages.nixpkgs.tor
        packages.nixpkgs.torbrowser
        packages.nixpkgs.traceroute
        packages.nixpkgs.tree
        packages.nixpkgs.vlc
        packages.nixpkgs.xclip
        packages.nixpkgs.yq
      ];
      stateVersion = "21.05";
      username = abs.username;
    };
    nixpkgs = {
      config = { };
      overlays = [
        (self: super: { })
      ];
    };
    programs = {
      bash = {
        enable = true;
        initExtra = builtins.readFile ./bashrc.sh;
        shellAliases = {
          a = "git add -p";
          bashrc = "code $MACHINE/bashrc.sh";
          bat = "bat --show-all --theme=ansi";
          c = "git commit --allow-empty";
          csv = "column -s, -t";
          cm = "git log -n 1 --format=%s%n%n%b";
          cr = "git commit -m \"$(cm)\"";
          f = "git fetch --all";
          graph = "TZ=UTC git rev-list --date=iso-local --pretty='!%H!!%ad!!%cd!!%aN!!%P!' --graph HEAD";
          l = "git log --show-signature";
          m = "git commit --amend --no-edit --allow-empty";
          machine = "code $MACHINE/default.nix";
          melts = "CI=true CI_COMMIT_REF_NAME=master melts";
          nix-flakes = "${packages.nixpkgs.nixUnstable}/bin/nix --experimental-features 'nix-command flakes'";
          now = "date --iso-8601=seconds --utc";
          p = "git push -f";
          r = "git pull --autostash --progress --rebase --stat origin master";
          ru = "git pull --autostash --progress --rebase --stat upstream master";
          rp = "r && p";
          s = "git status";
          today = "git log --format=%aI --author ${abs.emailAtWork} | sed -E 's/T.*$//g' | uniq -c | head -n 7 | tac";
        };
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
        extraConfig = ''
        '';
        plugins = [ ];
        settings = {
          background = "dark";
          mouse = "a";
        };
      };
      vscode = {
        enable = true;
        extensions =
          let
            ext = publisher: name: version: sha256:
              { inherit name publisher sha256 version; };
          in
          packages.nixpkgs.vscode-utils.extensionsFromVscodeMarketplace [
            (ext "4ops" "terraform" "0.2.1" "r5W5S9hIn4AlVtr6y7HoVwtJqZ+vYQgukj/ehJQRwKQ=")
            (ext "coenraads" "bracket-pair-colorizer" "1.0.61" "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652")
            (ext "eamodio" "gitlens" "11.3.0" "m2Zn+e6hj59SujcW5ptdrYDrc4CviZ4wyCndO2BhyF8=")
            (ext "jkillian" "custom-local-formatters" "0.0.4" "1pmqnc759fq86g2z3scx5xqpni9khcqi5z2kpl1kb7yygsv314gm")
            (ext "mads-hartmann" "bash-ide-vscode" "1.11.0" "d7acWLdRW8nVjQPU5iln9hl9zUx61XN4lvmFLbwLBMM=")
            (ext "shardulm94" "trailing-spaces" "0.3.1" "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8")
            (ext "tamasfe" "even-better-toml" "0.12.2" "1vz1sxkg24hsn4zfwzjdry4pp1hrc1fp516xpcyvq3ajr1xddlvs")
          ] ++ [
            packages.nixpkgs.vscode-extensions.bbenoist.Nix
            packages.nixpkgs.vscode-extensions.haskell.haskell
            packages.nixpkgs.vscode-extensions.justusadam.language-haskell
            packages.nixpkgs.vscode-extensions.ms-azuretools.vscode-docker
            packages.nixpkgs.vscode-extensions.ms-python.python
            packages.nixpkgs.vscode-extensions.ms-python.vscode-pylance
            packages.nixpkgs.vscode-extensions.streetsidesoftware.code-spell-checker
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
          exec = "${packages.timedoctor}/bin/timedoctor";
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
  flake = {
    lock = utils.fromJSON ./flake.lock;
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
    timedoctor = packages.nixpkgs.buildFHSUserEnvBubblewrap {
      name = "timedoctor";
      # DEBUG=true ELECTRON_ENABLE_LOGGING=true I18NEXT_LNG=en
      runScript = "appimage-exec.sh -w ${sources.timedoctor.extracted}";
      targetPkgs = _: [
        packages.nixpkgs.alsaLib
        packages.nixpkgs.appimageTools.appimage-exec
        packages.nixpkgs.atk
        packages.nixpkgs.at-spi2-atk
        packages.nixpkgs.at-spi2-core
        packages.nixpkgs.cairo
        packages.nixpkgs.coreutils
        packages.nixpkgs.cups
        packages.nixpkgs.dbus
        packages.nixpkgs.dbus.lib
        packages.nixpkgs.desktop-file-utils
        packages.nixpkgs.expat
        packages.nixpkgs.expat.dev
        packages.nixpkgs.file
        packages.nixpkgs.fontconfig
        packages.nixpkgs.freetype
        packages.nixpkgs.gcc
        packages.nixpkgs.gcc-unwrapped.lib
        packages.nixpkgs.gdb
        packages.nixpkgs.gdk-pixbuf
        packages.nixpkgs.git
        packages.nixpkgs.glib
        packages.nixpkgs.glibc
        packages.nixpkgs.gnome.gdk_pixbuf
        packages.nixpkgs.gnome.gtk
        packages.nixpkgs.gnome.gtk.dev
        packages.nixpkgs.gnome.zenity
        packages.nixpkgs.gnome2.GConf
        packages.nixpkgs.gnumake
        packages.nixpkgs.gnutar
        packages.nixpkgs.gpsd
        packages.nixpkgs.gtk3
        packages.nixpkgs.gtk3.dev
        packages.nixpkgs.gtk3-x11
        packages.nixpkgs.gtk3-x11.dev
        packages.nixpkgs.kdialog
        packages.nixpkgs.libappindicator-gtk2.out
        packages.nixpkgs.libexif
        packages.nixpkgs.libjpeg8.out
        packages.nixpkgs.libnotify
        packages.nixpkgs.libpng
        packages.nixpkgs.libxml2
        packages.nixpkgs.libxslt
        packages.nixpkgs.netcat
        packages.nixpkgs.nettools
        packages.nixpkgs.nodePackages.asar
        packages.nixpkgs.nspr
        packages.nixpkgs.nss
        packages.nixpkgs.openjdk
        packages.nixpkgs.pango
        packages.nixpkgs.patchelf
        packages.nixpkgs.python38
        packages.nixpkgs.strace
        packages.nixpkgs.sqlite
        packages.nixpkgs.sqlite.dev
        packages.nixpkgs.udev
        packages.nixpkgs.unzip
        packages.nixpkgs.utillinux
        packages.nixpkgs.watch
        packages.nixpkgs.wget
        packages.nixpkgs.which
        packages.nixpkgs.wrapGAppsHook
        packages.nixpkgs.xdg_utils
        packages.nixpkgs.xorg.libX11
        packages.nixpkgs.xorg.libXau
        packages.nixpkgs.xorg.libXaw
        packages.nixpkgs.xorg.libXaw3d
        packages.nixpkgs.xorg.libxcb
        packages.nixpkgs.xorg.libXcomposite
        packages.nixpkgs.xorg.libXcursor
        packages.nixpkgs.xorg.libXdamage
        packages.nixpkgs.xorg.libXdmcp
        packages.nixpkgs.xorg.libXext
        packages.nixpkgs.xorg.libXfixes
        packages.nixpkgs.xorg.libXfont
        packages.nixpkgs.xorg.libXfont2
        packages.nixpkgs.xorg.libXft
        packages.nixpkgs.xorg.libXi
        packages.nixpkgs.xorg.libXinerama
        packages.nixpkgs.xorg.libXmu
        packages.nixpkgs.xorg.libXp
        packages.nixpkgs.xorg.libXpm
        packages.nixpkgs.xorg.libXpresent
        packages.nixpkgs.xorg.libXrandr
        packages.nixpkgs.xorg.libXrender
        packages.nixpkgs.xorg.libXres
        packages.nixpkgs.xorg.libXScrnSaver
        packages.nixpkgs.xorg.libXt
        packages.nixpkgs.xorg.libXTrap
        packages.nixpkgs.xorg.libXtst
        packages.nixpkgs.xorg.libXv
        packages.nixpkgs.xorg.libXvMC
        packages.nixpkgs.xorg.libXxf86dga
        packages.nixpkgs.xorg.libXxf86misc
        packages.nixpkgs.xorg.libXxf86vm
        packages.nixpkgs.xorg.xcbutilkeysyms
        packages.nixpkgs.zip
        packages.nixpkgs.zlib
        packages.nixpkgs.zsh
      ];
    };
  };
  sources = {
    homeManager = /home/kamado/Documents/github/nix-community/home-manager;
    # homeManager = utils.fetchzip {
    #   url = "https://github.com/nix-community/home-manager/archive/0e6c61a44092e98ba1d75b41f4f947843dc7814d.tar.gz";
    #   sha256 = "0i6qjkyvxbnnvk984781wgkycdrgwf6cpbln7w35gfab18h7mnzy";
    # };
    nixpkgs = utils.fromGithub flake.lock.nodes.nixpkgs.locked;
    product = utils.fromGitlab flake.lock.nodes.product.locked;
    timedoctor = {
      appimage = utils.fetchurl {
        # https://repo2.timedoctor.com/td-desktop-hybrid/prod/
        url = "https://repo2.timedoctor.com/td-desktop-hybrid/prod/v3.12.9/timedoctor-desktop_3.12.9_linux-x86_64.AppImage";
        sha256 = "0li6w0y80k1ci8vi5xa0ihq6ay5xr266l3d74rbazkbx8g4vv1g9";
      };
      asar = packages.nixpkgs.stdenv.mkDerivation {
        name = "timedoctor-asar";
        builder = builtins.toFile "builder.sh" ''
          source $stdenv/setup
          asar e $envSrc/resources/app.asar $out
        '';
        buildInputs = [ packages.nixpkgs.nodePackages.asar ];
        envSrc = sources.timedoctor.extracted;
      };
      extracted = packages.nixpkgs.appimageTools.extract {
        name = "timedoctor-extracted";
        src = sources.timedoctor.appimage;
      };
    };
  };
  utils = {
    fetchzip = (import <nixpkgs> { }).fetchzip;
    fetchurl = (import <nixpkgs> { }).fetchurl;
    fromGithub = { narHash, owner, repo, rev, ... }: utils.fetchzip {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      hash = narHash;
    };
    fromGitlab = { narHash, owner, repo, rev, ... }: utils.fetchzip {
      url = "https://gitlab.com/${owner}/${repo}/-/archive/${rev}.tar.gz";
      hash = narHash;
    };
    fromJSON = path: builtins.fromJSON (builtins.readFile path);
    remoteImport = { args ? null, source }:
      if args == null
      then import source
      else import source args;
  };
}
