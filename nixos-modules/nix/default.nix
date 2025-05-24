{
  config,
  flakeInputs,
  pkgs,
  ...
}: {
  boot.readOnlyNixStore = false;
  environment.systemPackages = [
    (pkgs.alias "nix" config.nix.package ["--print-build-logs"])
  ];
  nix.extraOptions = ''
    extra-experimental-features = flakes nix-command pipe-operators
  '';
  nix.nixPath = ["nixpkgs=${flakeInputs.nixpkgs}"];
  nix.package = pkgs.nixVersions.latest;
  nix.registry.nixpkgs = {
    exact = false;
    flake = flakeInputs.nixpkgs;
  };
  nix.settings.cores = 0;
  nix.settings.max-jobs = 1;
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://alejandra.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "alejandra.cachix.org-1:NjZ8kI0mf4HCq8yPnBfiTurb96zp1TBWl8EC54Pzjm0="
  ];
  nix.settings.trusted-users = ["root" config.wellKnown.username];
}
