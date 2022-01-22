{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    makes.url = "github:fluidattacks/makes/main";
    makes.inputs.nixpkgs.follows = "nixpkgs";

    nixosGenerators.url = "github:nix-community/nixos-generators";
    nixosGenerators.inputs.nixpkgs.follows = "nixpkgs";

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      mkNixosSystem = { modules, system }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = rec {
            nixpkgs = import inputs.nixpkgs {
              config.allowUnfree = true;
              inherit system;
            };
            nixpkgsSrc = inputs.nixpkgs.sourceInfo;
            makes = import "${inputs.makes}/src/args/agnostic.nix" {
              inherit system;
            };
            makesSrc = inputs.makes.sourceInfo;
            pkgs = nixpkgs;
            pythonOnNix = inputs.pythonOnNix.packages.${system};
          };
          inherit system;
        };
    in
    {

      nixosModules = {
        audio = ./nixos-modules/audio;
        boot = ./nixos-modules/boot;
        browser = ./nixos-modules/browser;
        config = ./nixos-modules/config;
        editor = ./nixos-modules/editor;
        hardware = ./nixos-modules/hardware;
        homeManager = inputs.homeManager.nixosModule;
        networking = ./nixos-modules/networking;
        nix = ./nixos-modules/nix;
        secrets = ./nixos-modules/secrets;
        terminal = ./nixos-modules/terminal;
        ui = ./nixos-modules/ui;
        users = ./nixos-modules/users;
        virtualisation = ./nixos-modules/virtualisation;
        wellKnown = ./nixos-modules/well-known;
      };

      nixosConfigurations = {
        machine = mkNixosSystem {
          modules = builtins.attrValues inputs.self.nixosModules;
          system = "x86_64-linux";
        };

        machineIsoInstaller = mkNixosSystem {
          modules =
            let
              nixosModules = builtins.removeAttrs inputs.self.nixosModules [
                "boot"
                "hardware"
                "networking"
                "virtualisation"
              ];
            in
            [
              inputs.nixosGenerators.nixosModules.install-iso
              { imports = builtins.attrValues nixosModules; }
            ];
          system = "x86_64-linux";
        };
      };

      packages."x86_64-linux".installer =
        let nixosSystem = inputs.self.nixosConfigurations.machineIsoInstaller;
        in nixosSystem.config.system.build.${nixosSystem.config.formatAttr};

    };
}
