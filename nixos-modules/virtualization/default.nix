{config, ...}: {
  # boot.binfmt.emulatedSystems = [
  #   "aarch64-linux"
  #   "armv6l-linux"
  #   "armv7l-linux"
  #   "i686-linux"
  #   "i686-windows"
  #   "mipsel-linux"
  #   "x86_64-windows"
  # ];
  users.groups.docker = {};
  users.users.${config.wellKnown.username}.extraGroups = ["docker" "vboxusers"];
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  virtualisation.virtualbox.guest.enable = false;
  virtualisation.virtualbox.host.enable = false;
}
