{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
      makes = import "${inputs.makes}/src/args/agnostic.nix" {
        inherit system;
      };
      system = "x86_64-linux";
    in
    {

      nixosModules =
        let
          nixosModulesSrc = ./nixos-modules;
          nixosModules = builtins.mapAttrs
            (module: type: import "${nixosModulesSrc}/${module}")
            (builtins.readDir nixosModulesSrc);
        in
        nixosModules // {
          homeManager = inputs.homeManager.nixosModule;
        };

      nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
        modules = (builtins.attrValues inputs.self.nixosModules) ++ [{
          secrets.hashedPassword =
            # mkpasswd -m sha-512
            "$6$qQYhouD2P24RYK1H$Oc9BI/2wC7uydLXP5taS7LQgpTUbORwty/0sAGtwial7k9ZYQOmeyjZ5DxvmObdccPJHem2N/.afn/JtCJ2af.";
          secrets.path = "/data/github/kamadorueda/secrets";
          ui.timezone = "America/Bogota";
          wellKnown.email = "kamadorueda@gmail.com";
          wellKnown.name = "Kevin Amado";
          wellKnown.signingKey = "FFF341057F503148";
          wellKnown.username = "kamadorueda";
        }];
        specialArgs = rec {
          inherit nixpkgs;
          nixpkgsSrc = inputs.nixpkgs.sourceInfo;
          inherit makes;
          makesSrc = inputs.makes.sourceInfo;
          pkgs = nixpkgs;
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
        inherit system;
      };

    };
}
