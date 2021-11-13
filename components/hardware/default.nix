{ config, lib, pkgs, modulesPath, ... } @ attrs:

let
  autoDetected = import ./auto.nix attrs;
in
autoDetected // {
  swapDevices = [{
    device = "/swap";
    size = 4096; # MiB
  }];
}
