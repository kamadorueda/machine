{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: {

    nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./default.nix ];
    };

  };
}
