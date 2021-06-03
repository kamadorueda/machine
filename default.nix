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
      activation = {
        afterWriteBoundary = {
          after = [ "writeBoundary" ];
          before = [ ];
          data = ''
            find ~/.config/Code | while read -r path
            do
              $DRY_RUN_CMD chmod --recursive +w "$(readlink --canonicalize "$path")"
            done
          '';
        };
      };
      enableDebugInfo = true;
      file = {
        timedoctor = {
          executable = true;
          source = sources.timedoctor.appimage;
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
        packages.nixpkgs.gptfdisk
        packages.nixpkgs.git-sizer
        packages.nixpkgs.gimp
        packages.nixpkgs.gnumake

        packages.nixpkgs.google-chrome
        packages.nixpkgs.hugo
        packages.nixpkgs.inxi
        packages.nixpkgs.python38Packages.isort
        packages.nixpkgs.jq
        packages.nixpkgs.kubectl
        packages.nixpkgs.libreoffice
        packages.nixpkgs.lshw
        packages.nixpkgs.lsof
        packages.nixpkgs.maven
        packages.nixpkgs.mypy
        packages.nixpkgs.ngrok
        packages.nixpkgs.nix-index
        packages.nixpkgs.nixpkgs-fmt
        packages.nixpkgs.nodejs
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
        packages.nixpkgs.qemu
        packages.nixpkgs.shadow
        packages.nixpkgs.sops
        packages.nixpkgs.terraform
        packages.nixpkgs.tokei
        packages.nixpkgs.traceroute
        packages.nixpkgs.tree
        packages.nixpkgs.vlc
        packages.nixpkgs.xclip
        packages.nixpkgs.yq
        packages.nixpkgs3.nix-bundle
        packages.timedoctor
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
          commit.gpgsign = true;
          diff.sopsdiffer.textconv =
            (packages.nixpkgs.writeScript "sopsdiffer.sh" ''
              #! ${packages.nixpkgs.bash}/bin/bash
              sops -d "$1" || cat "$1"
            '').outPath;
          gpg.progam = "${packages.nixpkgs.gnupg}/bin/gpg2";
          gpg.sign = true;
          init.defaultBranch = "main";
          user.email = abs.email;
          user.name = abs.name;
          user.signingkey = abs.signingkey;
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
        };
      };
      vscode = {
        enable = true;
        extensions =
          let
            ext = publisher: name: version: sha256:
              { inherit name publisher sha256 version; };
          in
          packages.nixpkgs3.vscode-utils.extensionsFromVscodeMarketplace [
            (ext "4ops" "terraform" "0.2.1" "r5W5S9hIn4AlVtr6y7HoVwtJqZ+vYQgukj/ehJQRwKQ=")
            (ext "coenraads" "bracket-pair-colorizer" "1.0.61" "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652")
            (ext "eamodio" "gitlens" "11.3.0" "m2Zn+e6hj59SujcW5ptdrYDrc4CviZ4wyCndO2BhyF8=")
            (ext "jkillian" "custom-local-formatters" "0.0.4" "1pmqnc759fq86g2z3scx5xqpni9khcqi5z2kpl1kb7yygsv314gm")
            (ext "mads-hartmann" "bash-ide-vscode" "1.11.0" "d7acWLdRW8nVjQPU5iln9hl9zUx61XN4lvmFLbwLBMM=")
            (ext "shardulm94" "trailing-spaces" "0.3.1" "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8")
            (ext "tamasfe" "even-better-toml" "0.12.2" "1vz1sxkg24hsn4zfwzjdry4pp1hrc1fp516xpcyvq3ajr1xddlvs")
          ] ++ [
            packages.nixpkgs3.vscode-extensions.bbenoist.Nix
            packages.nixpkgs3.vscode-extensions.haskell.haskell
            packages.nixpkgs3.vscode-extensions.justusadam.language-haskell
            packages.nixpkgs3.vscode-extensions.ms-azuretools.vscode-docker
            packages.nixpkgs3.vscode-extensions.ms-python.python
            packages.nixpkgs3.vscode-extensions.ms-python.vscode-pylance
            packages.nixpkgs3.vscode-extensions.streetsidesoftware.code-spell-checker
          ];
        keybindings = [
        ];
        package = packages.nixpkgs3.vscode;
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
          ];
          "diffEditor.ignoreTrimWhitespace" = false;
          "diffEditor.maxComputationTime" = 0;
          "diffEditor.renderSideBySide" = false;
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
          name = "TimeDoctor";
          exec = "${abs.home}/${config.home.file.timedoctor.target}";
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
  packages = rec {
    desktime = packages.nixpkgs.stdenv.mkDerivation {
      autoPatchelfIgnoreMissingDeps = true;
      buildInputs = with packages.nixpkgs; [
        alsaLib
        ffmpeg-full
        gtk3
        nspr
        nss
        xorg.libXtst
        xorg.libXScrnSaver
      ];
      installPhase = "install -m755 -D $src/usr/bin/desktime-linux $out/bin/desktime";
      name = "desktime";
      nativeBuildInputs = [ packages.nixpkgs.autoPatchelfHook ];
      runtimeDependencies = [ sources.desktime.extracted ];
      src = sources.desktime.extracted;
    };
    desktime2 = nixpkgs.buildFHSUserEnvBubblewrap {
      name = "desktime";
      runScript = "${sources.desktime.extracted}/usr/bin/desktime-linux";
      targetPkgs = pkgs: with pkgs; [
        at-spi2-atk
        atk
        alsaLib
        cairo
        cups
        dbus
        expat.dev
        ffmpeg-full
        fontconfig.lib
        glib
        gdk-pixbuf
        gtk3
        nspr
        nss
        pango
        xlibs.libX11
        xlibs.xprop
        xorg.libxcb
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXrender
        xorg.libXi
        xorg.libXtst
        xorg.libXScrnSaver
      ];
    };
    homeManager = utils.remoteImport {
      args.pkgs = nixpkgs3;
      source = sources.homeManager;
    };
    nixpkgs = utils.remoteImport {
      args.config = { allowUnfree = true; };
      source = sources.nixpkgs;
    };
    nixpkgs3 = utils.remoteImport {
      args.config = { allowUnfree = true; };
      source = sources.nixpkgs3;
    };
    product = utils.remoteImport {
      source = sources.product;
    };
    timedoctor = nixpkgs.buildFHSUserEnvBubblewrap rec {
      name = "timedoctor";
      multiPkgs = targetPkgs;
      runScript = "appimage-exec.sh -w ${sources.timedoctor.extracted}";
      targetPkgs = pkgs: with pkgs; [
        alsaLib
        appimageTools.appimage-exec
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        desktop-file-utils
        dbus.lib
        expat.dev
        gdk-pixbuf
        glib
        gtk3
        nss
        nspr
        pango
        utillinux
        xorg.libxcb
        xorg.libX11
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXi
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libXScrnSaver
      ];
    };
  };
  sources =
    let
      fetchzip = (import <nixpkgs> { }).fetchzip;
      fetchurl = (import <nixpkgs> { }).fetchurl;
    in
    {
      desktime = {
        deb = fetchurl {
          url = "https://desktime.com/updates/linux/update";
          sha256 = "0rs0f9m20943fg3bc7q9rj6nig9x3pw0ridh9syid6v86nzlv82h";
        };
        extracted = packages.nixpkgs.runCommandLocal "desktime-src" { } ''
          ${packages.nixpkgs.dpkg}/bin/dpkg-deb -x ${sources.desktime.deb} $out
          ln -s $out/usr/lib/desktime-linux $out/lib
        '';
      };
      homeManager = /home/kamado/Documents/github/nix-community/home-manager;
      # homeManager = fetchzip {
      #   url = "https://github.com/nix-community/home-manager/archive/0e6c61a44092e98ba1d75b41f4f947843dc7814d.tar.gz";
      #   sha256 = "0i6qjkyvxbnnvk984781wgkycdrgwf6cpbln7w35gfab18h7mnzy";
      # };
      nixpkgs = fetchzip {
        url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
        sha256 = "1d4nyjylsvrv9r4ly431wilkswb2pnlfwwg0cagfjch60d4897qp";
      };
      nixpkgs3 = fetchzip {
        url = "https://github.com/nixos/nixpkgs/archive/a1d64d9419422ae9779ab5cada5828127a24e100.tar.gz";
        sha256 = "0gifxf5n9s0xrwcqgmpvibqa9ab3asx1jm65dsglgfgj9hg2qb0q";
      };
      product = fetchzip {
        url = "https://gitlab.com/fluidattacks/product/-/archive/e0a77b8bf17a9b6114e1ccb7d799a6246d9605c1.tar.gz";
        sha256 = "05nnnkhq0lxrdhsk83v33shrvpykj4j6i12c81mnlqfmibcaspy9";
      };
      timedoctor = {
        appimage = fetchurl {
          # https://repo2.timedoctor.com/td-desktop-hybrid/prod/
          url = "https://repo2.timedoctor.com/td-desktop-hybrid/prod/v3.12.9/timedoctor-desktop_3.12.9_linux-x86_64.AppImage";
          sha256 = "0li6w0y80k1ci8vi5xa0ihq6ay5xr266l3d74rbazkbx8g4vv1g9";
        };
        extracted = packages.nixpkgs.appimageTools.extract {
          name = "timedoctor-src";
          src = sources.timedoctor.appimage;
        };
      };
    };
  utils = {
    remoteImport = { args ? null, source }:
      if args == null
      then import source
      else import source args;
  };
}
