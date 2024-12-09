{
  config,
  nixosHardware,
  nixpkgs,
  ...
}: {
  imports = [nixosHardware.nixosModules.framework-11th-gen-intel];
  config = {
    boot.kernelPackages = nixpkgs.linuxPackages_latest;

    environment.systemPackages = [nixpkgs.wally-cli];
    hardware.bluetooth.enable = true;
    hardware.firmware = [
      nixpkgs.linux-firmware
      nixpkgs.wireless-regdb
    ];
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = [nixpkgs.intel-compute-runtime];
    hardware.keyboard.zsa.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    services.fwupd.enable = true;
    services.gnome.at-spi2-core.enable = true;
    # services.pipewire.pulse.enable = true;
    # services.xserver.videoDrivers = ["nvidia"];
  };
}
