{config, ...}: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.verbose = true;
  users.mutableUsers = false;
  users.users.root = {inherit (config.secrets) hashedPassword;};
  users.users.${config.wellKnown.username} = {
    extraGroups = ["wheel"];
    inherit (config.secrets) hashedPassword;
    inherit (config.wellKnown) home;
    isNormalUser = true;
  };
}
