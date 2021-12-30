{ config
, ...
}:

let
  inherit (config.wellKnown) username;
in
{
  users.groups.docker = { };
  users.users.${username}.extraGroups = [ "docker" ];
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "12:00";
  virtualisation.docker.autoPrune.flags = [ "-a" "-f" "--volumes" ];
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
}
