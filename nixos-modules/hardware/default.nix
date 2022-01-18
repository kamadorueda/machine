{ config
, nixpkgs
, ...
} @ args:

let
  autoDetected = import ./auto-detected.nix args;
in
autoDetected // {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = nixpkgs.bluez;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  services.xserver.videoDrivers = [ "nvidia" ];
  swapDevices = [ ];
}
