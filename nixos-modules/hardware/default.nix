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
  hardware.nvidia.package =
    let package = config.boot.kernelPackages.nvidiaPackages.stable;
    in builtins.trace "Nvidia driver version: ${package.version}" package;
  services.xserver.videoDrivers = [ "nvidia" ];
  swapDevices = [ ];
}
