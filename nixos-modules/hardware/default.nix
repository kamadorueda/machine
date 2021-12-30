args:

let
  autoDetected = import ./auto-detected.nix args;
in
autoDetected // {
  swapDevices = [{
    device = "/swap";
    size = 4096; # MiB
  }];
}
