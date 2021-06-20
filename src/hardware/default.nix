_: with _;

{ config
, lib
, modulesPath
, pkgs
, ...
} @ attrs:

(import ./local.nix attrs) // {
  swapDevices = [
    {
      device = "/swap";
      size = 8000; # MB
    }
  ];
}
