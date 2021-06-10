{
  description = "kamadorueda's machine, as code";
  inputs = {
    flakeCompat = { url = "github:edolstra/flake-compat"; flake = false; };
    nixpkgs = { url = "github:nixos/nixpkgs"; };
    product = { url = "gitlab:fluidattacks/product"; };
  };
  outputs = attrs: { };
}
