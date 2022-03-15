{
  config,
  nixpkgs,
  nixpkgsSrc,
  ...
}: let
  nixSystem = let
    package = nixpkgs.nix;
  in
    builtins.trace "Nix System: ${package.version}" package;

  nix = let
    package = nixpkgs.nixUnstable;
  in
    builtins.trace "Nix CLI: ${package.version}" package;
in {
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "nix" ''
      exec ${nix}/bin/nix \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes \
        --print-build-logs \
        "$@"
    '')
  ];
  nix.nixPath = ["nixpkgs=${nixpkgsSrc}"];
  nix.package = nixSystem;
  nix.readOnlyStore = false;
  nix.registry.nixpkgs = {
    exact = false;
    flake = nixpkgsSrc;
  };
  nix.settings.cores = 8;
  nix.settings.max-jobs = 2;
  nix.settings.substituters = ["https://nix-community.cachix.org"];
  nix.settings.trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  nix.settings.trusted-users = ["root" config.wellKnown.username];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  system.stateVersion = "21.05";
}
