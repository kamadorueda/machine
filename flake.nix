{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    flakeUtils.url = "github:numtide/flake-utils";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    makes.url = "github:fluidattacks/makes/main";
    makes.inputs.nixpkgs.follows = "nixpkgs";

    nixosGenerators.url = "github:nix-community/nixos-generators";
    nixosGenerators.inputs.nixpkgs.follows = "nixpkgs";

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.flakeUtils.follows = "flakeUtils";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: let
    system = "x86_64-linux";
    makes = import "${inputs.makes}/src/args/agnostic.nix" {inherit system;};
    mkNixosSystem = modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = rec {
          fenix = inputs.fenix.packages.${system};
          nixpkgs = import inputs.nixpkgs {
            config.allowUnfree = true;
            inherit system;
          };
          nixpkgsSrc = inputs.nixpkgs.sourceInfo;
          inherit makes;
          makesSrc = inputs.makes.sourceInfo;
          pkgs = nixpkgs;
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
        inherit system;
      };
  in {
    nixosModules = {
      audio = import ./nixos-modules/audio;
      boot = import ./nixos-modules/boot;
      browser = import ./nixos-modules/browser;
      buildkite = import ./nixos-modules/buildkite;
      config = import ./nixos-modules/config;
      editor = import ./nixos-modules/editor;
      hardware = import ./nixos-modules/hardware;
      homeManager = inputs.homeManager.nixosModule;
      networking = import ./nixos-modules/networking;
      nix = import ./nixos-modules/nix;
      secrets = import ./nixos-modules/secrets;
      terminal = import ./nixos-modules/terminal;
      ui = import ./nixos-modules/ui;
      users = import ./nixos-modules/users;
      virtualisation = import ./nixos-modules/virtualisation;
      wellKnown = import ./nixos-modules/well-known;
    };
    nixosConfigurations = {
      isoInstaller = mkNixosSystem (
        [inputs.nixosGenerators.nixosModules.install-iso]
        ++ (
          builtins.attrValues (
            builtins.removeAttrs inputs.self.nixosModules ["boot" "hardware" "networking" "virtualisation"]
          )
        )
      );
      machine = mkNixosSystem (builtins.attrValues inputs.self.nixosModules);
      virtualbox = mkNixosSystem (
        [inputs.nixosGenerators.nixosModules.virtualbox]
        ++ (
          builtins.attrValues (
            builtins.removeAttrs inputs.self.nixosModules ["boot" "hardware" "networking" "virtualisation"]
          )
        )
      );
    };
    packages."x86_64-linux" = {
      isoInstaller = let
        nixosSystem = inputs.self.nixosConfigurations.isoInstaller;
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
      machineJson =
        makes.toFileJson "machine.json"
        inputs.self.nixosConfigurations.machine.config.system.build;
      virtualbox = let
        nixosSystem = inputs.self.nixosConfigurations.virtualbox;
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
    };
  };
}
