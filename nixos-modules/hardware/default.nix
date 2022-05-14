{
  config,
  lib,
  nixosHardware,
  nixpkgs,
  ...
}: {
  options = {
    hardware.physicalCores = lib.mkOption {type = lib.types.int;};
  };
  imports = [nixosHardware.nixosModules.framework];
  config = {
    boot.kernelPackages = let
      packages = nixpkgs.linuxPackages_latest;
    in
      builtins.trace "Linux: ${packages.kernel.version}"
      packages;

    hardware.bluetooth.enable = true;
    hardware.enableAllFirmware = true;
    # hardware.nvidia.package = let
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    # in
    #   builtins.trace "Nvidia driver version: ${package.version}" package;
    # services.xserver.videoDrivers = ["nvidia"];
  };
}
