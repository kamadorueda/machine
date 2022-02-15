{
  config,
  ...
}:
{
  users.groups.docker = { };
  users.users.${config.wellKnown.username}.extraGroups = [ "docker" "vboxusers" ];
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
