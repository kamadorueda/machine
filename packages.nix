with import ./utils.nix;
with import ./sources.nix;
{
  packages = rec {
    homeManager = utils.remoteImport {
      args.pkgs = nixpkgs3;
      source = sources.homeManager;
    };
    nixpkgs = utils.remoteImport {
      args.config = { allowUnfree = true; };
      source = sources.nixpkgs;
    };
    nixpkgs3 = utils.remoteImport {
      args.config = { allowUnfree = true; };
      source = sources.nixpkgs3;
    };
    product = utils.remoteImport {
      source = sources.product;
    };
  };
}
