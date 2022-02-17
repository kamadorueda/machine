{
  config,
  nixpkgs,
  nixpkgsSrc,
  ...
}:
{
  environment.systemPackages = [
    (
      nixpkgs.writeShellScriptBin "nix" ''
        exec ${nixpkgs.nixUnstable}/bin/nix \
          --extra-experimental-features nix-command \
          --extra-experimental-features flakes \
          --print-build-logs \
          "$@"
      ''
    )
  ];
  nix.nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  nix.package = nixpkgs.nix;
  nix.readOnlyStore = false;
  nix.registry.nixpkgs = {
    exact = false;
    flake = nixpkgsSrc;
  };
  nix.settings.cores = 1;
  nix.settings.max-jobs = "auto";
  nix.settings.substituters = [ "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  nix.settings.trusted-users = [ "root" config.wellKnown.username ];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  system.stateVersion = "21.05";
}
