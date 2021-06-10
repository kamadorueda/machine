{
  description = "kamadorueda's machine, as code";
  inputs = {
    homeManager = { url = "github:nix-community/home-manager"; };
    nixpkgs = { url = "github:nixos/nixpkgs"; };
    product = { url = "gitlab:fluidattacks/product"; };
  };
  outputs = attrs: { };
}
