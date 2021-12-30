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

  outputs = inputs:
    let
      nixpkgs = import inputs.nixpkgs {
        config.allowUnfree = true;
        inherit system;
      };
      system = "x86_64-linux";
    in
    {

      nixosModules = {
        boot = import ./nixos-modules/boot;
        hardware = import ./nixos-modules/hardware;
        wellKnown = import ./nixos-modules/well-known;
      };

      nixosConfigurations.machine =
        let
          system = "x86_64-linux";
        in
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            inputs.homeManager.nixosModule
            inputs.self.nixosModules.boot
            inputs.self.nixosModules.hardware
            inputs.self.nixosModules.wellKnown

            {
              options.wellKnown.email = "kamadorueda@gmail.com";
            }
          ];
          specialArgs = rec {
            inherit nixpkgs;
            pkgs = nixpkgs;
          };
          inherit system;
        };

    };
}
