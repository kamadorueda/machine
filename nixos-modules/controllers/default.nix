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
    hardware.keyboard.zsa.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = [nixpkgs.intel-compute-runtime];
    hardware.pulseaudio.enable = true;
    services.fwupd.enable = true;
    services.gnome.at-spi2-core.enable = true;
    # services.xserver.videoDrivers = ["nvidia"];
  };
}
