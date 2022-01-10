{ config
, nixpkgs
, nixpkgsSrc
, ...
}:

{
  nix.buildCores = 4;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.registry.nixpkgs = {
    exact = false;
    flake = nixpkgsSrc;
  };
  nix.maxJobs = 4;
  nix.nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  nix.package = nixpkgs.nixUnstable;
  nix.trustedUsers = [ "root" config.wellKnown.username ];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  system.stateVersion = "21.05";
}
