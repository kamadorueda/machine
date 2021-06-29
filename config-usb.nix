let
  machine = import ./default.nix;
in
{
  imports = [
    machine.software
  ];
}
