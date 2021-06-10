{
  description = "kamadorueda's machine, as code";
  inputs = {
    homeManager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
    };
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
    };
    product = {
      type = "gitlab";
      owner = "fluidattacks";
      repo = "product";
    };
  };
  outputs = attrs: { };
}
