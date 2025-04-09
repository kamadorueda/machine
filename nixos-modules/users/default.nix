{config, ...}: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${config.wellKnown.username} = {
    home.stateVersion = config.system.stateVersion;
  };

  users.mutableUsers = false;
  users.users.root = {
    # mkpasswd -m sha-512
    hashedPasswordFile = config.sops.secrets.user-password.path;
  };
  users.users.${config.wellKnown.username} = {
    extraGroups = ["wheel"];
    hashedPasswordFile = config.sops.secrets.user-password.path;
    isNormalUser = true;
  };
}
