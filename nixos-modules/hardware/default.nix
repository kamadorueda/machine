args:

let
  autoDetected = import ./auto-detected.nix args;
in
autoDetected // {
  swapDevices = [ ];
}
