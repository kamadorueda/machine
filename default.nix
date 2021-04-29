{ flavor ? "all"
}:
let
  fetchzip = (import <nixpkgs> { }).fetchzip;

  remoteImport = { args ? null, source }:
    if args == null
    then import source
    else import source args;

  nixpkgs = remoteImport {
    args.config.allowUnfree = true;
    source = fetchzip {
      url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
      sha256 = "F5+ESAMGMumeYuBx7qi9YnE9aeRhEE9JTjtvTb30lrQ=";
    };
  };

  productSource = fetchzip {
    url = "https://gitlab.com/fluidattacks/product/-/archive/41aa1c5caf9e4122ffbf9690cb14a552ce3f7b23.tar.gz";
    sha256 = "1rvn9akx4v2mxpnxm99dcmd35il4yjdd856b51mhgzx6cmsqwpk1";
  };
  product = remoteImport {
    source = productSource;
  };

  base = [
    product.makes-dev-vscode
  ] ++ (with nixpkgs; [
    curl
    jq
    git
    google-chrome
    (writeTextDir "etc/profile.d/bashrc" (builtins.readFile ./bashrc.sh))
  ]);

  extra = [
    productSource
  ] ++ (with nixpkgs; [
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
