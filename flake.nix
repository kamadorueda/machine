{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    fenix.inputs.rust-analyzer-src.follows = "rustAnalyzer";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    nixIndex.url = "github:Mic92/nix-index-database";
    nixIndex.flake = false;

    nixosGenerators.url = "github:nix-community/nixos-generators";
    nixosGenerators.inputs.nixpkgs.follows = "nixpkgs";

    nixosHardware.url = "github:nixos/nixos-hardware/master";

    rustAnalyzer.url = "github:rust-lang/rust-analyzer";
    rustAnalyzer.flake = false;

    sopsNix.url = "github:mic92/sops-nix";
    sopsNix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    nixosModules = {
      _meta = import ./nixos-modules/_meta {inherit inputs;};

      browser = import ./nixos-modules/browser;

      buildkite = import ./nixos-modules/buildkite;

      controllers = import ./nixos-modules/controllers;

      editor = import ./nixos-modules/editor;

      fhs = import ./nixos-modules/fhs;
      fhsConfig = {pkgs, ...}: {
        fhs.packages = [
          pkgs.glibc.out
          pkgs.glibc.dev
          pkgs.openssl.out
          pkgs.openssl.dev
        ];
      };

      framework = inputs.nixosHardware.nixosModules.framework-11th-gen-intel;

      homeManager = inputs.homeManager.nixosModules.default;

      networking = import ./nixos-modules/networking;

      nix = import ./nixos-modules/nix;

      nixpkgs = import ./nixos-modules/nixpkgs;

      physical = import ./nixos-modules/physical;

      secrets = import ./nixos-modules/secrets;
      secretsConfig = {config, ...}: {
        secrets.ageKeyPath = "/data/age-key.txt";
      };

      sops = inputs.sopsNix.nixosModules.sops;

      terminal = import ./nixos-modules/terminal;

      ui = import ./nixos-modules/ui;
      uiConfig = {
        ui.fontSize = 16;
        ui.timezone = "America/Edmonton";
      };

      users = import ./nixos-modules/users;

      virtualization = import ./nixos-modules/virtualization;

      wellKnown = import ./nixos-modules/well-known;
      wellKnownConfig = {
        wellKnown.email = "kamadorueda@gmail.com";
        wellKnown.name = "Kevin Amado";
        wellKnown.username = "kamadorueda";
      };
    };

    nixosConfigurations = {
      machine = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = builtins.attrValues inputs.self.nixosModules;
      };
      installer = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixosGenerators.nixosModules.install-iso
          inputs.self.nixosModules._meta
          inputs.self.nixosModules.controllers
          inputs.self.nixosModules.nix
          inputs.self.nixosModules.nixpkgs
          inputs.self.nixosModules.wellKnown
          inputs.self.nixosModules.wellKnownConfig
          ({pkgs, ...}: {
            boot.supportedFilesystems = pkgs.lib.mkForce [
              "btrfs"
              "reiserfs"
              "vfat"
              "f2fs"
              "xfs"
              "ntfs"
              "cifs"
              # "zfs"
              "tmpfs"
              "auto"
              "squashfs"
              "tmpfs"
              "overlay"
            ];
          })
        ];
      };
    };

    packages."x86_64-linux" = {
      installer = let
        nixosSystem = inputs.self.nixosConfigurations.installer;
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
    };
  };
}
