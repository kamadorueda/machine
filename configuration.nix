with import ./default.nix;
{
  imports = [
    ./hardware-configuration.nix
    "${sources.homeManager}/nixos"
    config
  ];
}
