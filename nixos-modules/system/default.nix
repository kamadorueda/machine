{
  config,
  nixosHardware,
  nixpkgs,
  ...
}: {
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 60;
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.package = nixpkgs.bluezFull;
  imports = [./auto-detected.nix];
  swapDevices = [
    {
      device = "/swap";
      size = 16384;
    }
  ];
}
