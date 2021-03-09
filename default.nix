{ flavor ? "all"
}:
let
  nixpkgsSource = (import <nixpkgs> { }).fetchzip {
    url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
    sha256 = "F5+ESAMGMumeYuBx7qi9YnE9aeRhEE9JTjtvTb30lrQ=";
  };
  nixpkgs = import nixpkgsSource {
    config.allowUnfree = true;
  };

  base = with nixpkgs; [
    curl
    jq
    git
    google-chrome
    (writeTextDir "etc/profile.d/bashrc" (builtins.readFile ./bashrc.sh))
    (vscode-with-extensions.override {
      vscodeExtensions = nixpkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "bash-ide-vscode";
          publisher = "mads-hartmann";
          sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
          version = "1.11.0";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          sha256 = "1ba72sr7mv9c0xzlqlxbv1x8p6jjvdjkkf7dn174v8b8345164v6";
          version = "11.2.1";
        }
        {
          name = "vscode-pylance";
          publisher = "ms-python";
          sha256 = "07zapnindwi79k5a2v5ywgwfiqzgs79li73y56rpq0n3a287z4q6";
          version = "2021.2.3";
        }
        {
          name = "terraform";
          publisher = "4ops";
          sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
          version = "0.2.1";
        }
      ] ++ [
        nixpkgs.vscode-extensions.bbenoist.Nix
        nixpkgs.vscode-extensions.ms-azuretools.vscode-docker
        nixpkgs.vscode-extensions.ms-python.python
      ];
    })
  ];

  extra = with nixpkgs; [
    awscli
    gnupg
    kubectl
    libreoffice
    ngrok nixpkgs-fmt nodejs
    optipng
    pcre
    vim vlc
    tree
    yq
  ];
in
if (flavor == "all") then (base ++ extra)
else if (flavor == "base") then (base)
else abort "Flavor must be one of: base, all"
