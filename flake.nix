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

    pythonOnNix.url = "github:on-nix/python/main";
    pythonOnNix.inputs.makes.follows = "makes";
    pythonOnNix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: let
    system = "x86_64-linux";

    mkNixosSystem = modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = rec {
          alejandra = inputs.alejandra.defaultPackage.${system};
          fenix = inputs.fenix.packages.${system};
          nixpkgs = import inputs.nixpkgs {
            config.allowUnfree = true;
            inherit system;
          };
          nixpkgsSrc = inputs.nixpkgs.sourceInfo;
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
      machine = mkNixosSystem (builtins.attrValues inputs.self.nixosModules);
    };

    packages."x86_64-linux" = {
      isoInstaller = let
        nixosSystem = mkNixosSystem (
          [inputs.nixosGenerators.nixosModules.install-iso]
          ++ (builtins.attrValues (builtins.removeAttrs inputs.self.nixosModules [
            "boot"
            "hardware"
            "networking"
            "virtualisation"
          ]))
        );
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};

      # machineJson = let
      #   isOption = value:
      #     builtins.typeOf value
      #     == "set"
      #     && builtins.hasAttr "name" value
      #     && builtins.hasAttr "description" value
      #     && builtins.hasAttr "type" value
      #     && builtins.hasAttr "_type" value.type
      #     && value.type == "option-type";

      #   maxDepth = 3;

      #   recurse = path: value:
      #     if builtins.typeOf value == "set"
      #     then
      #       builtins.foldl'
      #       (result: name:
      #         result
      #         // (
      #           if isOption value.${name}
      #           then {
      #             "${builtins.concatStringsSep "." path}" = value.${name}.value;
      #           }
      #           else if
      #             builtins.length path
      #             <= maxDepth
      #             && (!isOption value.${name}
      #               || (value.${name}.isDefined
      #                 && value.${name}.visible))
      #             && !builtins.elem name ["pkgs"]
      #           then builtins.trace "${name}" (recurse (path ++ [name]) value.${name})
      #           else {}
      #         ))
      #       {}
      #       (builtins.attrNames value)
      #     else {};

      #   generate = config: recurse [] config.options;
      # in
      #   # makes.toFileJson "machine.json"
      #   (generate inputs.self.nixosConfigurations.machine);

      qemuKvm = let
        nixosSystem = mkNixosSystem (
          [inputs.nixosGenerators.nixosModules.vm-bootloader]
          ++ (builtins.attrValues (builtins.removeAttrs inputs.self.nixosModules [
            "boot"
            "hardware"
            "networking"
            "virtualisation"
          ]))
        );
      in
        nixosSystem.config.system.build.${nixosSystem.config.formatAttr};
    };
  };
}
