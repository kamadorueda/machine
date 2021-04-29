{ flavor ? "all"
}:
let
  # Host functions
  fetchzip = (import <nixpkgs> { }).fetchzip;

  # Sources
  sources = {
    nixpkgs = fetchzip {
      url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
      sha256 = "F5+ESAMGMumeYuBx7qi9YnE9aeRhEE9JTjtvTb30lrQ=";
    };
    product = fetchzip {
      url = "https://gitlab.com/fluidattacks/product/-/archive/41aa1c5caf9e4122ffbf9690cb14a552ce3f7b23.tar.gz";
      sha256 = "1rvn9akx4v2mxpnxm99dcmd35il4yjdd856b51mhgzx6cmsqwpk1";
    };
  };

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
    python39
    python310
    sops
    tokei
    tree
    vim
    xclip
    yq
  ]);
in
if (flavor == "all") then (base ++ extra)
else if (flavor == "base") then (base)
else abort "Flavor must be one of: base, all"
