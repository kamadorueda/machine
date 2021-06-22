_: with _; {
  homeManager = utils.remoteImport {
    args = {
      pkgs = packages.nixpkgs;
    };
    source = sources.homeManager;
  };
  nixpkgs = utils.remoteImport {
    args = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        (self: super: {
          libjpeg8 = super.libjpeg.override {
            enableJpeg8 = true;
          };
        })
      ];
    };
    source = sources.nixpkgs;
  };
  product = utils.remoteImport {
    source = sources.product;
  };
}
