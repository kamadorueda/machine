{config, ...}: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${config.wellKnown.username} = {
    home.stateVersion = config.system.stateVersion;
  };

  users.mutableUsers = false;
  users.users.root = {
    inherit (config.secrets) hashedPasswordFile;
  };
  users.users.${config.wellKnown.username} = {
    extraGroups = ["wheel"];
    inherit (config.secrets) hashedPasswordFile;
    isNormalUser = true;
  };
}
