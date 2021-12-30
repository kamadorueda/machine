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
      makes = import "${inputs.makes}/src/args/agnostic.nix" {
        inherit system;
      };
      system = "x86_64-linux";
    in
    {

      nixosModules = {
        boot = import ./nixos-modules/boot;
        browser = import ./nixos-modules/browser;
        editor = import ./nixos-modules/editor;
        hardware = import ./nixos-modules/hardware;
        nix = import ./nixos-modules/nix;
        secrets = import ./nixos-modules/secrets;
        terminal = import ./nixos-modules/terminal;
        ui = import ./nixos-modules/ui;
        users = import ./nixos-modules/users;
        virtualisation = import ./nixos-modules/virtualisation;
        wellKnown = import ./nixos-modules/well-known;
      };

      nixosConfigurations.machine = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.homeManager.nixosModule
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.verbose = true;
          }
          inputs.self.nixosModules.boot
          inputs.self.nixosModules.browser
          inputs.self.nixosModules.editor
          inputs.self.nixosModules.hardware
          inputs.self.nixosModules.nix
          inputs.self.nixosModules.secrets
          {
            secrets.hashedPassword =
              # mkpasswd -m sha-512
              "$6$lN51G8gh$ETrEWKgyhHPtt3PiMMkB1brrUwORe70KYONhxMhXcXSY7.zswV/FvrMuKV.uTIRvPbm4mvMp0EeP7Fv15mUh2.";
          }
          inputs.self.nixosModules.ui
          {
            ui.locale = "en_US.UTF-8";
            ui.timezone = "America/Bogota";
          }
          inputs.self.nixosModules.terminal
          inputs.self.nixosModules.users
          inputs.self.nixosModules.virtualisation
          inputs.self.nixosModules.wellKnown
          {
            wellKnown.email = "kamadorueda@gmail.com";
            wellKnown.name = "Kevin Amado";
            wellKnown.signingKey = "FFF341057F503148";
            wellKnown.username = "kamadorueda";
          }
        ];
        specialArgs = rec {
          inherit nixpkgs;
          nixpkgsSrc = inputs.nixpkgs.outPath;
          inherit makes;
          makesSrc = inputs.makes.outPath;
          pkgs = nixpkgs;
          pythonOnNix = inputs.pythonOnNix.packages.${system};
        };
        inherit system;
      };

    };
}
