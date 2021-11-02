_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = ''
      echo wiping root device...
      mkdir /tmp/root
      ${packages.nixpkgs.utillinux}/bin/mount \
        /dev/disk/by-label/root /tmp/root
      rm -fr /tmp/root/*
      ${packages.nixpkgs.utillinux}/bin/umount /tmp/root
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
