{
  inputs = {
    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    makes.url = "github:fluidattacks/makes/main";
    makes.inputs.nixpkgs.follows = "nixpkgs";

    nixosGenerators.url = "github:nix-community/nixos-generators";
    nixosGenerators.inputs.nixpkgs.follows = "nixpkgs";

    nixosHardware.url = "github:nixos/nixos-hardware/master";

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: let
    nixpkgsSrc = let
      nixpkgsSrc = inputs.nixpkgs.sourceInfo;
    in
      builtins.trace
      "Nixpkgs: ${inputs.nixpkgs.sourceInfo.lastModifiedDate}"
      nixpkgsSrc;

    system = "x86_64-linux";

    nixpkgs = import nixpkgsSrc {
      config.allowUnfree = true;
      inherit system;
    };

    mkNixosSystem = modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = rec {
          alejandra = inputs.alejandra.defaultPackage.${system};
          fenix = inputs.fenix.packages.${system};
          nixosHardware = inputs.nixosHardware;
          inherit nixpkgs;
          inherit nixpkgsSrc;
          makes = import "${inputs.makes}/src/args/agnostic.nix" {inherit system;};
          makesSrc = inputs.makes.sourceInfo;
          pkgs = nixpkgs;
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
        inherit system;
      };
  in {
    nixosModules = {
      audio = import ./nixos-modules/audio;

      browser = import ./nixos-modules/browser;

      buildkite = import ./nixos-modules/buildkite;

      editor = import ./nixos-modules/editor;

      hardware = import ./nixos-modules/hardware;
      hardwareConfig = {
        hardware.physicalCores = 4;
      };

      homeManager = inputs.homeManager.nixosModule;

      networking = import ./nixos-modules/networking;

      nix = import ./nixos-modules/nix;

      secrets = import ./nixos-modules/secrets;
      secretsConfig = {
        secrets.hashedPassword =
          # mkpasswd -m sha-512
          "$6$qQYhouD2P24RYK1H$Oc9BI/2wC7uydLXP5taS7LQgpTUbORwty/0sAGtwial7k9ZYQOmeyjZ5DxvmObdccPJHem2N/.afn/JtCJ2af.";
        secrets.path = "/data/secrets";
      };

      system = import ./nixos-modules/system;

      terminal = import ./nixos-modules/terminal;

      ui = import ./nixos-modules/ui;
      uiConfig = {
        ui.fontSize = 16;
        ui.timezone = "America/Edmonton";
      };

      users = import ./nixos-modules/users;

      virtualisation = import ./nixos-modules/virtualisation;

      wellKnown = import ./nixos-modules/well-known;
      wellKnownConfig = {
        wellKnown.email = "kamadorueda@gmail.com";
        wellKnown.name = "Kevin Amado";
        wellKnown.username = "kamadorueda";
      };
    };

    nixosConfigurations = {
      machine = mkNixosSystem (builtins.attrValues inputs.self.nixosModules);
    };

    packages."x86_64-linux" = {
      installer = let
        nixosSystem = mkNixosSystem [
          inputs.nixosGenerators.nixosModules.install-iso
          inputs.self.nixosModules.hardware
          inputs.self.nixosModules.hardwareConfig
          inputs.self.nixosModules.nix
          inputs.self.nixosModules.wellKnown
          inputs.self.nixosModules.wellKnownConfig
        ];
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
    };
  };
}
