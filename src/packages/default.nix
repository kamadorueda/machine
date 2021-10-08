_: with _; {
  homeManager = utils.remoteImport {
    args = {
      pkgs = packages.nixpkgs;
    };
    source = sources.homeManager;
  };
  makes = utils.remoteImport {
    args = { };
    source = "${sources.makes}/src/args/agnostic.nix";
  };
  nixpkgs = utils.remoteImport {
    args = {
      config = {
        allowUnfree = true;
      };
    };
    source = sources.nixpkgs;
  };
  nixpkgsNixos = utils.remoteImport {
    args = { };
    source = sources.nixpkgsNixos;
  };
  nixpkgsTimedoctor = utils.remoteImport {
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
    source = sources.nixpkgsTimedoctor;
  };
  pythonOnNix = utils.remoteImport {
    source = sources.pythonOnNix;
  };
}
