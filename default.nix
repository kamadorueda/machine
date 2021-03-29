{ flavor ? "all"
}:
let
  fetchzip = (import <nixpkgs> { }).fetchzip;

  remoteImport = { sha256, url }:
    let source = fetchzip { inherit sha256 url; };
    in import source;

  nixpkgs = remoteImport
    {
      url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
      sha256 = "F5+ESAMGMumeYuBx7qi9YnE9aeRhEE9JTjtvTb30lrQ=";
    }
    {
      config.allowUnfree = true;
    };

  product = remoteImport {
    url = "https://gitlab.com/fluidattacks/product/-/archive/c04415b77e7870b8ebb238135644f257eae15f9e.tar.gz";
    sha256 = "09zywsqww4y9y2g40qyyd4ks8f2k8sxasvayw8ffmvv5fvwrr41h";
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
    pcre
    (python38.withPackages (pkgs: with pkgs; [
    ]))
    python39
    python310
    tree
    vim
    xclip
    yq
  ];
in
if (flavor == "all") then (base ++ extra)
else if (flavor == "base") then (base)
else abort "Flavor must be one of: base, all"
