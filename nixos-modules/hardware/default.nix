{
  config,
  lib,
  nixpkgs,
  ...
} @ args: let
  nvidiaPackage = let
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  in
    builtins.trace "Nvidia driver version: ${package.version}" package;
in {
  swapDevices = [
    {
      device = "/swap";
      size = 16384;
    }
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = nixpkgs.bluez;
  hardware.nvidia.package = nvidiaPackage;
  imports = [./auto-detected.nix];
  services.xserver.videoDrivers = ["nvidia"];
}
