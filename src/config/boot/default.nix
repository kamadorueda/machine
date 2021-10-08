_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postDeviceCommands = ''
      set -x
      sleep 5
      echo wiping root device...
      mkdir /tmp/root
      mount /dev/disk/by-label/root /tmp/root
      rm -fr /tmp/root/*
      umount /tmp/root
      set +x
      sleep 60
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
