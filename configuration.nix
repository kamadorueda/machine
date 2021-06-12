let
  machine = import ./default.nix;
in
{
  imports = [
    machine.config
    machine.hardware
    "${machine.sources.homeManager}/nixos"
  ];
}
