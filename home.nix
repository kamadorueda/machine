with import ./packages.nix;
with import ./sources.nix;
with import ./utils.nix;
{
  # Home manager configuration:
  # https://nix-community.github.io/home-manager/options.html

  home = {
    packages = [
      (packages.nixpkgs.awscli)
      (packages.nixpkgs.black)
      (packages.nixpkgs.burpsuite)
      (packages.nixpkgs.cabal-install)
      (packages.nixpkgs.cargo)
      (packages.nixpkgs.curl)
      (packages.nixpkgs.diction)
      (packages.nixpkgs.diffoscope)
      (packages.nixpkgs.direnv)
      (packages.nixpkgs.gcc)
      (packages.nixpkgs.ghc)
      (packages.nixpkgs.gnumake)
      (packages.nixpkgs.gnupg)
      (packages.nixpkgs.google-chrome)
      (packages.nixpkgs.hugo)
      (packages.nixpkgs.jq)
      (packages.nixpkgs.kubectl)
      (packages.nixpkgs.libreoffice)
      (packages.nixpkgs.maven)
      (packages.nixpkgs.mypy)
      (packages.nixpkgs.ngrok)
      (packages.nixpkgs.nixpkgs-fmt)
      (packages.nixpkgs.nodejs)
      (packages.nixpkgs.optipng)
      (packages.nixpkgs.parallel)
      (packages.nixpkgs.pcre)
      (packages.nixpkgs.peek)
      (packages.nixpkgs.python38)
      (packages.nixpkgs.sops)
      (packages.nixpkgs.terraform)
      (packages.nixpkgs.tokei)
      (packages.nixpkgs.tree)
      (packages.nixpkgs.vim)
      (packages.nixpkgs.vlc)
      (packages.nixpkgs.xclip)
      (packages.nixpkgs.yq)
      (utils.directory "product" sources.product)
    ];
  };
  nixpkgs = {
    config = { };
  };
  programs = {
    bash = {
      bashrcExtra = builtins.readFile ./bashrc.sh;
      enable = true;
      profileExtra = ". ~/.nix-profile/etc/profile.d/nix.sh";
    };
    git = {
      enable = true;
      extraConfig = {
        commit.gpgsign = true;
        gpg.progam = "gpg2";
        gpg.sign = true;
        init.defaultBranch = "main";
        user.email = "kamadorueda@gmail.com";
        user.name = "Kevin Amado";
        user.signingkey = "FFF341057F503148";
      };
      package = packages.nixpkgs.git;
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
        "python.defaultInterpreterPath" = "/home/kamado/.nix-profile/bin/python";
        "python.formatting.blackArgs" = [
          "--config"
          "/home/kamado/.nix-profile/product/makes/utils/python-format/settings-black.toml"
        ];
        "python.formatting.blackPath" = "/home/kamado/.nix-profile/bin/black";
        "python.formatting.provider" = "black";
        "python.languageServer" = "Pylance";
        "python.linting.enabled" = true;
        "python.linting.lintOnSave" = true;
        "python.linting.mypyArgs" = [
          "--config-file"
          "/home/kamado/.nix-profile/product/makes/utils/lint-python/settings-mypy.cfg"
        ];
        "python.linting.mypyEnabled" = true;
        "python.linting.prospectorArgs" = [
          "--profile"
          "/home/kamado/.nix-profile/product/makes/utils/lint-python/settings-prospector.yaml"
        ];
        "python.linting.prospectorEnabled" = true;
        "python.linting.pylintEnabled" = false;
        "telemetry.enableTelemetry" = false;
        "update.mode" = "none";
        "window.zoomLevel" = 2;
        "workbench.startupEditor" = "none";
        "workbench.editor.enablePreview" = false;
      };
    };
  };
}
