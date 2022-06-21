{
  config,
  nixosHardware,
  nixpkgs,
  ...
}: {
  imports = [nixosHardware.nixosModules.framework];
  config = {
    boot.kernelPackages = let
      packages = nixpkgs.linuxPackages_latest;
    in
      builtins.trace "Linux: ${packages.kernel.version}"
      packages;

    hardware.bluetooth.enable = true;
    hardware.firmware = [
      nixpkgs.linux-firmware
      nixpkgs.wireless-regdb
    ];
    hardware.nvidia.package = let
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    in
      builtins.trace "Nvidia driver version: ${package.version}" package;
    hardware.opengl.extraPackages = [
      nixpkgs.intel-compute-runtime
    ];
    hardware.pulseaudio.enable = true;
    services.gnome.at-spi2-core.enable = true;
    # services.xserver.videoDrivers = ["nvidia"];
  };
}
