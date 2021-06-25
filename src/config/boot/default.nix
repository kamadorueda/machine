_: with _; {
  cleanTmpDir = true;
  initrd = {
    luks = {
      reusePassphrases = true;
    };
    postMountCommands = packages.nixpkgs.lib.mkAfter ''
      set -x || true
      rm -rf /eph || true
      set +x || true
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
