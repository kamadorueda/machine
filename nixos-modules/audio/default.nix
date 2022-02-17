{
  config,
  ...
}:
{
  hardware.pulseaudio.enable = true;
  services.gnome.at-spi2-core.enable = true;
  users.users.${config.wellKnown.username}.extraGroups = ["audio"];
}
