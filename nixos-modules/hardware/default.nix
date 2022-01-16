args:

let
  autoDetected = import ./auto-detected.nix args;
in
autoDetected // {
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  services.xserver.videoDrivers = [ "nvidia" ];
  swapDevices = [ ];
}
