_: with _; {
  homeManager = utils.remoteImport {
    args = {
      pkgs = packages.nixpkgs;
    };
    source = sources.homeManager;
  };
  makes = utils.remoteImport {
    args = {
      __globalStateDir__ = "$HOME_IMPURE/.makes/state";
      __projectStateDir__ = "$HOME_IMPURE/.makes/state/machine";
    };
    source = "${sources.makes}/src/args/agnostic.nix";
  };
  nixpkgs = utils.remoteImport {
    args = {
      config = {
        allowUnfree = true;
        android_sdk = {
          accept_license = true;
        };
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
  pythonOnNix = utils.remoteImport {
    source = sources.pythonOnNix;
  };
}
