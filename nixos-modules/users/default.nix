{config, ...}: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${config.wellKnown.username} = {
    home.stateVersion = config.system.stateVersion;
  };

  users.mutableUsers = false;
  users.users.root = {
    inherit (config.secrets) hashedPassword;
  };
  users.users.${config.wellKnown.username} = {
    extraGroups = ["wheel"];
    inherit (config.secrets) hashedPassword;
    isNormalUser = true;
  };
}
