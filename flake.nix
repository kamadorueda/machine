{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    homeManager.url = "github:nix-community/home-manager/master";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";

    nixosGenerators.url = "github:nix-community/nixos-generators";
    nixosGenerators.inputs.nixpkgs.follows = "nixpkgs";

    nixosHardware.url = "github:nixos/nixos-hardware/master";
  };
  outputs = inputs: let
    system = "x86_64-linux";

    nixpkgs = import inputs.nixpkgs {
      config.allowUnfree = true;
      inherit system;
    };

    mkNixosSystem = modules:
      import "${inputs.nixpkgs}/nixos/lib/eval-config.nix" {
        lib = nixpkgs.lib.extend (_: _: {});
        inherit modules;
        specialArgs = rec {
          fenix = inputs.fenix.packages.${system};
          inherit (inputs) nixosHardware;
          inherit nixpkgs;
          nixpkgsSrc = inputs.nixpkgs;
          pkgs = nixpkgs;
        };
        inherit system;
      };
  in {
    nixosModules = {
      browser = import ./nixos-modules/browser;

      buildkite = import ./nixos-modules/buildkite;

      controllers = import ./nixos-modules/controllers;

      editor = import ./nixos-modules/editor;

      fhs = import ./nixos-modules/fhs;
      fhsConfig = {
        fhs.packages = [
          nixpkgs.glibc.out
          nixpkgs.glibc.dev
          nixpkgs.openssl.out
          nixpkgs.openssl.dev
        ];
      };

      homeManager = inputs.homeManager.nixosModule;

      # k8s = import ./nixos-modules/k8s;

      mysql = import ./nixos-modules/mysql;

      networking = import ./nixos-modules/networking;

      nix = import ./nixos-modules/nix;

      postgresql = import ./nixos-modules/postgresql;

      physical = import ./nixos-modules/physical;

      secrets = import ./nixos-modules/secrets;
      secretsConfig = {
        secrets.hashedPassword =
          # mkpasswd -m sha-512
          "$6$uDZpDg74HGXwOkrT$2AMzk03bGfI7eQSPIJi0T8GHprmm5/opYiFSjgRRZxbJTB1QbwrE4sxFteAvpeAXK.4V/3UhwbViFe68B3an//";
        secrets.path = "/data/machine/secrets";
      };

      spark = import ./nixos-modules/spark;

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
