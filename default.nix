rec {
  # Home manager configuration:
  # https://nix-community.github.io/home-manager/options.html
  config = {
    home = {
      activation = {
        afterWriteBoundary = {
          after = [ "writeBoundary" ];
          before = [ ];
          data = ''
            $DRY_RUN_CMD chmod +w "$(readlink -f ~/.config/Code/User/settings.json)"
          '';
        };
      };
      enableDebugInfo = true;
      language = {
        address = "en_US.UTF-8";
        base = "en_US.UTF-8";
        collate = "en_US.UTF-8";
        ctype = "en_US.UTF-8";
        name = "en_US.UTF-8";
        numeric = "en_US.UTF-8";
        measurement = "en_US.UTF-8";
        messages = "en_US.UTF-8";
        monetary = "en_US.UTF-8";
        paper = "en_US.UTF-8";
        telephone = "en_US.UTF-8";
        time = "en_US.UTF-8";
      };
      packages = [
        (packages.nixpkgs.acpi)
        (packages.nixpkgs.age)
        (packages.nixpkgs.awscli)
        (packages.nixpkgs.beep)
        (packages.nixpkgs.bind)
        (packages.nixpkgs.binutils)
        (packages.nixpkgs.black)
        (packages.nixpkgs.burpsuite)
        (packages.nixpkgs.cabal-install)
        (packages.nixpkgs.cargo)
        (packages.nixpkgs.curl)
        (packages.nixpkgs.diction)
        (packages.nixpkgs.diffoscope)
        (packages.nixpkgs.evtest)
        (packages.nixpkgs.gcc)
        (packages.nixpkgs.ghc)
        (packages.nixpkgs.gptfdisk)
        (packages.nixpkgs.git-sizer)
        (packages.nixpkgs.gimp)
        (packages.nixpkgs.gnumake)
        (packages.nixpkgs.gnupg)
        (packages.nixpkgs.google-chrome)
        (packages.nixpkgs.hugo)
        (packages.nixpkgs.inxi)
        (packages.nixpkgs.jq)
        (packages.nixpkgs.kubectl)
        (packages.nixpkgs.libreoffice)
        (packages.nixpkgs.lshw)
        (packages.nixpkgs.lsof)
        (packages.nixpkgs.maven)
        (packages.nixpkgs.mypy)
        (packages.nixpkgs.ngrok)
        (packages.nixpkgs.nix-index)
        (packages.nixpkgs.nixpkgs-fmt)
        (packages.nixpkgs.nodejs)
        (packages.nixpkgs.openjdk)
        (packages.nixpkgs.optipng)
        (packages.nixpkgs.parallel)
        (packages.nixpkgs.parted)
        (packages.nixpkgs.pciutils)
        (packages.nixpkgs.pcre)
        (packages.nixpkgs.peek)
        (packages.nixpkgs.python38)
        (packages.nixpkgs.qemu)
        (packages.nixpkgs.shadow)
        (packages.nixpkgs.sops)
        (packages.nixpkgs.terraform)
        (packages.nixpkgs.tokei)
        (packages.nixpkgs.traceroute)
        (packages.nixpkgs.tree)
        (packages.nixpkgs.vim)
        (packages.nixpkgs.vlc)
        (packages.nixpkgs.xclip)
        (packages.nixpkgs.yq)
        (packages.nixpkgs3.nix-bundle)
        (packages.timedoctor)
      ];
    };
    nixpkgs = {
      config = { };
      overlays = [
        (self: super: { })
      ];
    };
    programs = {
      bash = {
        bashrcExtra = builtins.readFile ./bashrc.sh;
        enable = true;
        shellAliases = {
          "a" = "git add -p";
          "c" = "git commit --allow-empty";
          "csv" = "column -s, -t";
          "cat" = "bat --show-all --theme=ansi";
          "cm" = "git log -n 1 --format=%s%n%n%b";
          "cr" = "git commit -m \"$(cm)\"";
          "f" = "git fetch --all";
          "graph" = "TZ=UTC git rev-list --date=iso-local --pretty='!%H!!%ad!!%cd!!%aN!!%P!' --graph HEAD";
          "l" = "git log --show-signature";
          "m" = "git commit --amend --no-edit --allow-empty";
          "melts" = "CI=true CI_COMMIT_REF_NAME=master melts";
          "p" = "git push -f";
          "r" = "git pull --autostash --progress --rebase --stat origin master";
          "rp" = "r && p";
          "s" = "git status";
          "today" = "git log --format=%aI --author kamado@fluidattacks.com | sed -E 's/T.*$//g' | uniq -c | head -n 7 | tac";
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
          gpg.progam = "gpg2";
          gpg.sign = true;
          init.defaultBranch = "main";
          user.email = "kamadorueda@gmail.com";
          user.name = "Kevin Amado";
          user.signingkey = "FFF341057F503148";
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
              backgroundColor = "#2E3436";
              foregroundColor = "#D3D7C1";
              palette = [
                "#000000"
                "#AA0000"
                "#00AA00"
                "#AA5500"
                "#0000AA"
                "#AA00AA"
                "#00AAAA"
                "#AAAAAA"
                "#555555"
                "#FF5555"
                "#55FF55"
                "#FFFF55"
                "#5555FF"
                "#FF55FF"
                "#55FFFF"
                "#FFFFFF"
              ];
            };
            cursorBlinkMode = "off";
            cursorShape = "underline";
            default = true;
            deleteBinding = "delete-sequence";
            font = "Monospace Regular 22";
            scrollbackLines = 1000000;
            scrollOnOutput = false;
            showScrollbar = false;
            transparencyPercent = 8;
            visibleName = "kamadorueda";
          };
        };
        showMenubar = false;
        themeVariant = "dark";
      };
      powerline-go = {
        enable = true;
        modules = [
          "cwd"
          "gitlite"
          "time"
          "nix-shell"
        ];
        newline = true;
        settings = {
          mode = "flat";
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
            (ext "eamodio" "gitlens" "11.3.0" "m2Zn+e6hj59SujcW5ptdrYDrc4CviZ4wyCndO2BhyF8=")
            (ext "mads-hartmann" "bash-ide-vscode" "1.11.0" "d7acWLdRW8nVjQPU5iln9hl9zUx61XN4lvmFLbwLBMM=")
            (ext "4ops" "terraform" "0.2.1" "r5W5S9hIn4AlVtr6y7HoVwtJqZ+vYQgukj/ehJQRwKQ=")
            (ext "shardulm94" "trailing-spaces" "0.3.1" "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8")
            (ext "coenraads" "bracket-pair-colorizer" "1.0.61" "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652")
          ] ++ [
            packages.nixpkgs3.vscode-extensions.bbenoist.Nix
            packages.nixpkgs3.vscode-extensions.haskell.haskell
            packages.nixpkgs3.vscode-extensions.justusadam.language-haskell
            packages.nixpkgs3.vscode-extensions.ms-azuretools.vscode-docker
            packages.nixpkgs3.vscode-extensions.ms-python.python
            packages.nixpkgs3.vscode-extensions.ms-python.vscode-pylance
            packages.nixpkgs3.vscode-extensions.streetsidesoftware.code-spell-checker
          ];
        package = packages.nixpkgs3.vscode;
        userSettings = {
          "[html]" = {
            "editor.formatOnSave" = false;
          };
          "[py]" = {
            "editor.tabSize" = 4;
          };
          "editor.formatOnSave" = true;
          "editor.rulers" = [ 80 ];
          "editor.tabSize" = 2;
          "extensions.autoUpdate" = false;
          "files.insertFinalNewline" = true;
          "files.trimFinalNewlines" = true;
          "files.trimTrailingWhitespace" = true;
          "python.defaultInterpreterPath" = "${packages.nixpkgs.python38}/bin/python";
          "python.formatting.blackArgs" = [
            "--config"
            "${sources.product}/makes/utils/python-format/settings-black.toml"
          ];
          "python.formatting.blackPath" = "${packages.nixpkgs.black}/bin/black";
          "python.formatting.provider" = "black";
          "python.languageServer" = "Pylance";
          "python.linting.enabled" = true;
          "python.linting.lintOnSave" = true;
          "python.linting.mypyArgs" = [
            "--config-file"
            "${sources.product}/makes/utils/lint-python/settings-mypy.cfg"
          ];
          "python.linting.mypyEnabled" = true;
          "python.linting.prospectorArgs" = [
            "--profile"
            "${sources.product}/makes/utils/lint-python/settings-prospector.yaml"
          ];
          "python.linting.prospectorEnabled" = true;
          "python.linting.pylintEnabled" = false;
          "python.pythonPath" = "${packages.nixpkgs.python38}/bin/python";
          "telemetry.enableTelemetry" = false;
          "update.mode" = "none";
          "window.zoomLevel" = 2;
          "workbench.editor.enablePreview" = false;
          "workbench.editorAssociations" = [
            {
              "filenamePattern" = "*.ipynb";
              "viewType" = "jupyter.notebook.ipynb";
            }
          ];
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
        url = "https://gitlab.com/fluidattacks/product/-/archive/41aa1c5caf9e4122ffbf9690cb14a552ce3f7b23.tar.gz";
        sha256 = "1rvn9akx4v2mxpnxm99dcmd35il4yjdd856b51mhgzx6cmsqwpk1";
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
