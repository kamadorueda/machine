{pkgs, ...}: let
  inherit (pkgs.lib.meta) getExe';
in {
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
      ${getExe' pkgs.util-linux "mount"} /dev/disk/by-label/root /tmp/root
      rm -fr /tmp/root/*
      ${getExe' pkgs.util-linux "umount"} /tmp/root
    '';
    swapDevices = [
      {
        device = "/swap";
        size = 16384;
      }
    ];
  };
}
