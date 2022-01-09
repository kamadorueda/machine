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
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
      chainloader (hd0,1)+1
    }
  '';
  boot.loader.grub.gfxmodeBios = "auto";
  boot.loader.grub.gfxmodeEfi = "auto";
  boot.loader.grub.gfxpayloadBios = "text";
  boot.loader.grub.gfxpayloadEfi = "text";
  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = null;
}
