{
  inputs = {
    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.fenix.follows = "fenix";
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
    system = "x86_64-linux";

    nixpkgs = import inputs.nixpkgs {
      config.allowUnfree = true;
      inherit system;
    };

    mkNixosSystem = modules:
      import "${inputs.nixpkgs}/nixos/lib/eval-config.nix" {
        lib = nixpkgs.lib.extend (_: lib: {});
        inherit modules;
        specialArgs = rec {
          alejandra = inputs.alejandra.defaultPackage.${system};
          fenix = inputs.fenix.packages.${system};
          fenixSrc = inputs.fenix;
          inherit (inputs) nixosHardware;
          inherit nixpkgs;
          nixpkgsSrc = inputs.nixpkgs;
          makes = import "${inputs.makes}/src/args/agnostic.nix" {inherit system;};
          makesSrc = inputs.makes;
          pkgs = nixpkgs;
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
        inherit system;
      };
  in {
    nixosModules = {
      # books = import ./nixos-modules/books;

      browser = import ./nixos-modules/browser;

      buildkite = import ./nixos-modules/buildkite;

      controllers = import ./nixos-modules/controllers;

      editor = import ./nixos-modules/editor;

      homeManager = inputs.homeManager.nixosModule;

      # k8s = import ./nixos-modules/k8s;

      # mysql = import ./nixos-modules/mysql;

      networking = import ./nixos-modules/networking;

      nix = import ./nixos-modules/nix;

      postgresql = import ./nixos-modules/postgresql;

      physical = import ./nixos-modules/physical;

      secrets = import ./nixos-modules/secrets;
      secretsConfig = {
        secrets.hashedPassword =
          # mkpasswd -m sha-512
          "$6$qQYhouD2P24RYK1H$Oc9BI/2wC7uydLXP5taS7LQgpTUbORwty/0sAGtwial7k9ZYQOmeyjZ5DxvmObdccPJHem2N/.afn/JtCJ2af.";
        secrets.path = "/data/machine/secrets";
      };

      # spark = import ./nixos-modules/spark;

      terminal = import ./nixos-modules/terminal;

      ui = import ./nixos-modules/ui;
      uiConfig = {
        ui.fontSize = 16;
        ui.timezone = "America/Edmonton";
      };

      users = import ./nixos-modules/users;

      # virtualization = import ./nixos-modules/virtualization;

      wellKnown = import ./nixos-modules/well-known;
      wellKnownConfig = {
        wellKnown.email = "kamadorueda@gmail.com";
        wellKnown.name = "Kevin Amado";
        wellKnown.username = "kamadorueda";
      };
    };

    nixosConfigurations = {
      machine = mkNixosSystem (builtins.attrValues inputs.self.nixosModules);
      installer = mkNixosSystem [
        inputs.nixosGenerators.nixosModules.install-iso
        inputs.self.nixosModules.controllers
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.wellKnown
        inputs.self.nixosModules.wellKnownConfig
        {
          boot.supportedFilesystems = nixpkgs.lib.mkForce [
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
        }
      ];
    };

    packages."x86_64-linux" = {
      installer = let
        nixosSystem = inputs.self.nixosConfigurations.installer;
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
    };
  };
}
