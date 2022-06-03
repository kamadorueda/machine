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
    boot.initrd.postDeviceCommands = ''
      echo wiping root device...
      mkdir /tmp/root
      ${nixpkgs.utillinux}/bin/mount /dev/disk/by-label/root /tmp/root
      rm -fr /tmp/root/*
      ${nixpkgs.utillinux}/bin/umount /tmp/root
      sleep 10
    '';
    swapDevices = [
      {
        device = "/swap";
        size = 16384;
      }
    ];
  };
}
