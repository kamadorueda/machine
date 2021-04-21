{ flavor ? "all"
}:
let
  fetchzip = (import <nixpkgs> { }).fetchzip;

  remoteImport = { sha256, url, args ? null }:
    let source = fetchzip { inherit sha256 url; };
    in
    if args == null
    then import source
    else import source args;

  nixpkgs = remoteImport {
    args.config.allowUnfree = true;
    url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
    sha256 = "F5+ESAMGMumeYuBx7qi9YnE9aeRhEE9JTjtvTb30lrQ=";
  };

  product = remoteImport {
    url = "https://gitlab.com/fluidattacks/product/-/archive/e3f9decfcacbe410caf36d53053e824aff9e57cc.tar.gz";
    sha256 = "0l7ray17fnhfz8l3clc1r6wp3xi8y652a0dnzaj6pmmlijdlrl9z";
  };

  base = with nixpkgs; [
    curl
    jq
    git
    google-chrome
    product.makes-dev-vscode
    (writeTextDir "etc/profile.d/bashrc" (builtins.readFile ./bashrc.sh))
  ];

  extra = with nixpkgs; [
    awscli
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
    ngrok
    nixpkgs-fmt
    nodejs
    optipng
    parallel
    pcre
    peek
    product.melts
    (python38.withPackages (pkgs: with pkgs; [ ]))
    (python39.withPackages (pkgs: with pkgs; [ ]))
    (python310.withPackages (pkgs: with pkgs; [ ]))
    sops
    tokei
    tree
    vim
    xclip
    yq
  ];
in
if (flavor == "all") then (base ++ extra)
else if (flavor == "base") then (base)
else abort "Flavor must be one of: base, all"
