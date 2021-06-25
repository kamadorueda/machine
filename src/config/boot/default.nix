_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = packages.nixpkgs.lib.mkAfter ''
      ${packages.nixpkgs.coreutils}/bin/echo wiping root device...
      ${packages.nixpkgs.coreutils}/bin/mkdir /mnt-root
      ${packages.nixpkgs.utillinux}/bin/mount /dev/disk/by-label/root /mnt-root
      ${packages.nixpkgs.coreutils}/bin/rm -fr /mnt-root/*
      ${packages.nixpkgs.utillinux}/bin/umount /mnt-root
      ${packages.nixpkgs.coreutils}/bin/sleep 5
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
