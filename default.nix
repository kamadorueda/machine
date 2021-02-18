let
  nixpkgsSource = (import <nixpkgs> { }).fetchzip {
    # HEAD of release-20.09
    url = "https://github.com/nixos/nixpkgs/archive/2118cf551b9944cfdb929b8ea03556f097dd0381.zip";
    sha256 = "0ajsxh1clbf3q643gi8v6b0i0nn358hak0f265j7c1lrsbxyw457";
  };
  nixpkgs = import nixpkgsSource {
    config.allowUnfree = true;
  };
in
[
  (nixpkgs.awscli)
  (nixpkgs.git)
  (nixpkgs.gnupg)
  (nixpkgs.google-chrome)
  (nixpkgs.jq)
  (nixpkgs.kubectl)
  (nixpkgs.nixpkgs-fmt)
  (nixpkgs.vim)
  (nixpkgs.vscode-with-extensions.override {
    vscodeExtensions = nixpkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "bash-ide-vscode";
        publisher = "mads-hartmann";
        version = "1.11.0";
        sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.2.1";
        sha256 = "1ba72sr7mv9c0xzlqlxbv1x8p6jjvdjkkf7dn174v8b8345164v6";
      }
      {
        name = "terraform";
        publisher = "4ops";
        version = "0.2.1";
        sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
      }
    ] ++ [
      nixpkgs.vscode-extensions.bbenoist.Nix
      nixpkgs.vscode-extensions.ms-azuretools.vscode-docker
      nixpkgs.vscode-extensions.ms-python.python
    ];
  })
  (nixpkgs.tree)
  (nixpkgs.yq)
]
