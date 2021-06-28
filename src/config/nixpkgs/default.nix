_: with _; {
  config = {
    allowBroken = false;
    allowUnfree = true;
  };
  pkgs = packages.nixpkgs;
}
