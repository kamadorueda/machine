_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = with packages.nixpkgs; lib.mkAfter ''
      ${coreutils}/bin/echo wiping root device...
      ${coreutils}/bin/mkdir /mnt-root
      ${utillinux}/bin/mount /dev/disk/by-label/root /mnt-root
      ${coreutils}/bin/rm -fr /mnt-root/*
      ${utillinux}/bin/umount /mnt-root
      ${coreutils}/bin/sleep 5
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
