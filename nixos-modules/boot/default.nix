{ config
, nixpkgs
, ...
}:

{
  boot.initrd.postDeviceCommands = ''
    echo erasing: ${config.fileSystems."/".device}
    mkdir /tmp/mnt
    ${nixpkgs.utillinux}/bin/mount ${config.fileSystems."/".device} /tmp/mnt
    rm -fr /tmp/mnt/*
    ${nixpkgs.utillinux}/bin/umount /tmp/mnt
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
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 60;
}
