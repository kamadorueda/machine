with import ./utils.nix;
with import ./sources.nix;
{
  packages = {
    nixpkgs = utils.remoteImport {
      args.config.allowUnfree = true;
      source = sources.nixpkgs;
    };
    product = utils.remoteImport {
      source = sources.product;
    };
  };
}
