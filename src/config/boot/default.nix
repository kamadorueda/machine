_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = packages.nixpkgs.lib.mkAfter ''
      ${packages.nixpkgs.utillinux}/bin/lsblk

      ${packages.nixpkgs.coreutils}/bin/mkdir /root
      ${packages.nixpkgs.utillinux}/bin/mount /dev/disk/by-label/root /root
      ${packages.nixpkgs.coreutils}/bin/rm -fr /root/*
      ${packages.nixpkgs.findutils}/bin/find /root
      ${packages.nixpkgs.utillinux}/bin/umount /root
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
