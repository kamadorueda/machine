{ config
, nixpkgs
, nixpkgsSrc
, ...
}:

{
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "nix3" ''
      exec ${nixpkgs.nixUnstable}/bin/nix \
        --experimental-features "nix-command flakes" \
        --print-build-logs \
        --verbose "$@"
    '')
  ];
  nix.buildCores = 1;
  nix.registry.nixpkgs = {
    exact = false;
    flake = nixpkgsSrc;
  };
  nix.maxJobs = "auto";
  nix.nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  nix.package = nixpkgs.nix;
  nix.trustedUsers = [ "root" config.wellKnown.username ];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  system.stateVersion = "21.05";
}
