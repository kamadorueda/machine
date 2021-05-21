{ flavor ? "all"
}:
let
  # Sources
  sources = import ./sources.nix;

  # Functions
  directory = dir: src:
    pkgs.nixpkgs.runCommand dir { inherit dir src; } ''
      mkdir $out
      cp -r $src $out/$dir
    '';
  remoteImport = { args ? null, source }:
    if args == null
    then import source
    else import source args;

  # Package sets
  pkgs = {
    nixpkgs = remoteImport {
      args.config.allowUnfree = true;
      source = sources.nixpkgs;
    };
    product = remoteImport {
      source = sources.product;
    };
  };

  # Package lists
  base = (with pkgs.product; [
    makes-dev-vscode
  ]) ++ (with pkgs.nixpkgs; [
    curl
    jq
    git
    google-chrome
    (writeTextDir "etc/profile.d/bashrc" (builtins.readFile ./bashrc.sh))
    home-manager
  ]);

  extra = ([
    (directory "product" sources.product)
  ]) ++ (with pkgs.product; [
  ]) ++ (with pkgs.nixpkgs; [
    awscli
    black
    burpsuite
    cabal-install
    cargo
    diction
    diffoscope
    direnv
    gcc
    ghc
    gnumake
    gnupg
    hugo
    kubectl
    libreoffice
    maven
    mypy
    ngrok
    nixpkgs-fmt
    nodejs
    optipng
    parallel
    pcre
    peek
    python38
    sops
    terraform
    tokei
    tree
    vim
    vlc
    xclip
    yq
  ]);
in
if (flavor == "all") then (base ++ extra)
else if (flavor == "base") then (base)
else abort "Flavor must be one of: base, all"
