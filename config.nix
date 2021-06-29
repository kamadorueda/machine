let
  machine = import ./default.nix;
in
{
  imports = [
    machine.hardware
    machine.software
  ];
}
