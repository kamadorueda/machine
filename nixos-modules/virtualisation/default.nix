{ config
, ...
}:

{
  users.groups.docker = { };
  users.users.${config.wellKnown.username}.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;
}
