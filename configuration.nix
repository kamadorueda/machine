let
  machine = import ./default.nix;
in
{
  imports = [
    machine.hardware
    "${machine.sources.homeManager}/nixos"
    machine.config
  ];
}
