let
  machine = import ./default.nix;
in
{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    "${sources.homeManager}/nixos"
    machine.config
  ];
}
