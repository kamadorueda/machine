{ config
, ...
}:

{
  users.groups.docker = { };
  users.users.${config.wellKnown.username}.extraGroups = [ "docker" ];
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "12:00";
  virtualisation.docker.autoPrune.flags = [ "-a" "-f" "--volumes" ];
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
}
