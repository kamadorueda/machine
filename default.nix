let
  pkgs = import ((import <nixpkgs> {}).fetchzip {
    # HEAD of release-20.09
    url = "https://github.com/nixos/nixpkgs/archive/2118cf551b9944cfdb929b8ea03556f097dd0381.zip";
    sha256 = "0ajsxh1clbf3q643gi8v6b0i0nn358hak0f265j7c1lrsbxyw457";
  }) {
   config.allowUnfree = true;
  };
in
with pkgs; [
  (git)
  (google-chrome) 
  (vim)
  (vscode)
]
