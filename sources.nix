let
  fetchzip = (import <nixpkgs> { }).fetchzip;
in
{
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
}
