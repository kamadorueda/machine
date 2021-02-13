let
  nixpkgs = import ((import <nixpkgs> {}).fetchzip {
    # HEAD of release-20.09
    url = "https://github.com/nixos/nixpkgs/archive/2118cf551b9944cfdb929b8ea03556f097dd0381.zip";
    sha256 = "0ajsxh1clbf3q643gi8v6b0i0nn358hak0f265j7c1lrsbxyw457";
  }) {
   config.allowUnfree = true;
  };
in
[
  (nixpkgs.git)
  (nixpkgs.google-chrome) 
  (nixpkgs.vim)
  (nixpkgs.vscode-with-extensions.override {
    vscodeExtensions = nixpkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "bash-ide-vscode";
      publisher = "mads-hartmann";
      version = "1.11.0";
      sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
    } {
      name = "terraform";
      publisher = "4ops";
      version = "0.2.1";
      sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
    }] ++ [
      nixpkgs.vscode-extensions.bbenoist.Nix
      nixpkgs.vscode-extensions.ms-python.python
    ];
  })
]