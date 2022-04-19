{
  config,
  nixpkgs,
  nixpkgsSrc,
  ...
}: {
  environment.systemPackages = [
    (nixpkgs.writeShellScriptBin "nix" ''
      exec ${config.nix.package}/bin/nix \
        --print-build-logs \
        "$@"
    '')
  ];
  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
  '';
  nix.nixPath = ["nixpkgs=${nixpkgsSrc}"];
  nix.package = let
    package = nixpkgs.nixUnstable;
  in
    builtins.trace "Nix: ${package.version}" package;
  nix.readOnlyStore = false;
  nix.registry.nixpkgs = {
    exact = false;
    flake = nixpkgsSrc;
  };
  nix.settings.cores =
    config.hardware.physicalCores / config.nix.settings.max-jobs;
  nix.settings.max-jobs = 2;
  nix.settings.substituters = ["https://nix-community.cachix.org"];
  nix.settings.trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  nix.settings.trusted-users = ["root" config.wellKnown.username];
  nixpkgs.config.allowBroken = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  system.stateVersion = "21.05";
}
