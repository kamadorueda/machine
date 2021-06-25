_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postMountCommands = packages.nixpkgs.lib.mkAfter ''
      ${packages.nixpkgs.coreutils}/bin/mkdir /eph
      ${packages.nixpkgs.utillinux}/bin/mount /dev/disk/by-partlabel/ext4 /eph
      ${packages.nixpkgs.coreutils}/bin/rm -rf /eph
      ${packages.nixpkgs.utillinux}/bin/umount /eph
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
