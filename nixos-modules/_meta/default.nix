{inputs}: {pkgs, ...}: {
  _module.args = {
    flakeInputs = inputs;
    nixpkgs = pkgs;
    nixpkgsSrc = inputs.nixpkgs;
  };
  nixpkgs.overlays = [
    inputs.fenix.overlays.default
  ];
}
