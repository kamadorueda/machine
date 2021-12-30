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
      wellKnown = rec {
        email = "kamadorueda@gmail.com";
        username = "kamadorueda";

        # mkpasswd -m sha-512
        hashedPassword = "$6$lN51G8gh$ETrEWKgyhHPtt3PiMMkB1brrUwORe70KYONhxMhXcXSY7.zswV/FvrMuKV.uTIRvPbm4mvMp0EeP7Fv15mUh2.";
      };
    in
    {

      nixosModules = {
        boot = import ./nixos-modules/boot;
        hardware = import ./nixos-modules/hardware;
        nix = import ./nixos-modules/nix;
        ui = import ./nixos-modules/ui;
        users = import ./nixos-modules/users;
        virtualisation = import ./nixos-modules/virtualisation;
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
            inputs.self.nixosModules.nix
            inputs.self.nixosModules.ui
            inputs.self.nixosModules.users
            inputs.self.nixosModules.virtualisation
            inputs.self.nixosModules.wellKnown

            { inherit wellKnown; }
          ];
          specialArgs = rec {
            inherit nixpkgs;
            nixpkgsSrc = inputs.nixpkgs.outPath;
            pkgs = nixpkgs;
          };
          inherit system;
        };

    };
}
