let
  fetchzip = (import <nixpkgs> { }).fetchzip;
in
{
  sources = {
    nixpkgs = fetchzip {
      url = "https://github.com/nixos/nixpkgs/archive/932941b79c3dbbef2de9440e1631dfec43956261.tar.gz";
      sha256 = "1d4nyjylsvrv9r4ly431wilkswb2pnlfwwg0cagfjch60d4897qp";
    };
    nixpkgs3 = fetchzip {
      url = "https://github.com/nixos/nixpkgs/archive/a1d64d9419422ae9779ab5cada5828127a24e100.tar.gz";
      sha256 = "0gifxf5n9s0xrwcqgmpvibqa9ab3asx1jm65dsglgfgj9hg2qb0q";
    };
    product = fetchzip {
      url = "https://gitlab.com/fluidattacks/product/-/archive/41aa1c5caf9e4122ffbf9690cb14a552ce3f7b23.tar.gz";
      sha256 = "1rvn9akx4v2mxpnxm99dcmd35il4yjdd856b51mhgzx6cmsqwpk1";
    };
  };
}
