{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgsTimedoctor.url = "github:nixos/nixpkgs/7310407d493ee1c7caf38f8181507d7ac9c90eb8";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    makes.url = "github:fluidattacks/makes/main";
    makes.inputs.nixpkgs.follows = "nixpkgs";

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {

    nixosModules = {
      hardware = import ./components/hardware;
    };

    nixosConfigurations.machine =
      let
        machine = import ./default.nix inputs;
        system = "x86_64-linux";
      in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = rec {
          nixpkgs = import inputs.nixpkgs {
            config.allowUnfree = true;
            inherit system;
          };
          pkgs = nixpkgs;
        };
        modules = [
          inputs.homeManager.nixosModule
          inputs.self.nixosModules.hardware
          machine.config
        ];
        inherit system;
      };

  };
}
