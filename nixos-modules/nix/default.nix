{ config
, nixpkgs
, nixpkgsSrc
, ...
}:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.maxJobs = 1;
  nix.nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "12:00" ];
  nix.package = nixpkgs.nixUnstable;
  nix.trustedUsers = [ "root" config.wellKnown.username ];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
}
