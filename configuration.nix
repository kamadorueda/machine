with import ./default.nix;
{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    "${sources.homeManager}/nixos"
    config
  ];
}
