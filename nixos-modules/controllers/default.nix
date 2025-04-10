{
  config,
  pkgs,
  ...
}: {
  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    environment.systemPackages = [pkgs.wally-cli];
    hardware.bluetooth.enable = true;
    hardware.firmware = [
      pkgs.linux-firmware
      pkgs.wireless-regdb
    ];
    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = [pkgs.intel-compute-runtime];
    hardware.keyboard.zsa.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    services.fwupd.enable = true;
    services.gnome.at-spi2-core.enable = true;
    # services.xserver.videoDrivers = ["nvidia"];
  };
}
