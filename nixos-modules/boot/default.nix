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
  boot.kernelPackages =
    let packages = nixpkgs.linuxPackages_latest;
    in builtins.trace "Linux kernel version: ${packages.kernel.version}" packages;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 60;
}
