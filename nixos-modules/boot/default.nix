{ nixpkgs, ... }:

{
  boot.initrd.postDeviceCommands = ''
    echo wiping root device...
    mkdir /tmp/root
    ${nixpkgs.utillinux}/bin/mount /dev/disk/by-label/root /tmp/root
    rm -fr /tmp/root/*
    ${nixpkgs.utillinux}/bin/umount /tmp/root
  '';
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
}
