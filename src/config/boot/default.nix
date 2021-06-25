_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = packages.nixpkgs.lib.mkAfter ''
      set -x
      mkdir /post-device || true
      mount /dev/disk/by-partlabel/ext4 /post-device || true
      rm -rf /post-device || true
      umount /post-device || true
      set +x
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
