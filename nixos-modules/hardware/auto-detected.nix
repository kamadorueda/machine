# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9f54d61e-e074-410f-bd7c-dde6ffb716ce";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/514499a4-8b3b-4bac-ba47-6155f794e2e1";
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/72d69883-df0d-4cc8-b3cf-7dcc6dd88719";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptnix".device = "/dev/disk/by-uuid/4a69900d-903d-4a9e-830f-399de371b420";
  fileSystems."/nix/store" = {
    device = "/nix/store";
    fsType = "none";
    options = [ "bind" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E749-6614";
    fsType = "vfat";
  };
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/ee78c93a-7651-4f15-ad37-8ed0ebc4dd17";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."cryptdata".device = "/dev/disk/by-uuid/94b078ab-0407-4549-8a2d-aefd4ad5bc9d";
  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
