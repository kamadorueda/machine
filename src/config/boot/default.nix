_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = packages.nixpkgs.lib.mkAfter ''
      ${packages.nixpkgs.utillinux}/bin/lsblk

      ${packages.nixpkgs.coreutils}/bin/mkdir /eph
      ${packages.nixpkgs.utillinux}/bin/mount /dev/disk/by-partlabel/root /eph
      ${packages.nixpkgs.coreutils}/bin/rm -fr /eph/*
      ${packages.nixpkgs.findutils}/bin/find /eph
      ${packages.nixpkgs.utillinux}/bin/umount /eph
      ${packages.nixpkgs.utillinux}/bin/lsblk

      ${packages.nixpkgs.coreutils}/bin/sleep 15
    '';
  };
  loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      useOSProber = true;
    };
    systemd-boot = {
      enable = true;
    };
  };
  tmpOnTmpfs = false;
}
