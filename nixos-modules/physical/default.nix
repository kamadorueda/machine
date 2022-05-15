{
  config,
  lib,
  nixosHardware,
  nixpkgs,
  ...
}: {
  imports = [./auto-detected.nix];

  config = {
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.timeout = 60;
    swapDevices = [
      {
        device = "/swap";
        size = 16384;
      }
    ];
  };
}
