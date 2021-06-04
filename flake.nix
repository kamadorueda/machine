{
  description = "Kamadorueda's development machine, as code!";
  inputs = {
    # home-manager.url = "github:nix-community/home-manager";
    home-manager = {
      url = "file:///home/kamado/Documents/github/nix-community/home-manager";
      flake = false;
    };
  };
  outputs = { self, home-manager, ... }: {
    apps.x86_64-linux.home-manager = {
      type = "app";
      program = "${home-manager.defaultPackage.x86_64-linux}/bin/home-manager";
    };

    homeConfigurations = {
      kamadorueda = home-manager.lib.homeManagerConfiguration
        (import ./default.nix).config;
    };
  };
}
