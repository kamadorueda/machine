# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6cd3873e-9a53-4bb1-adc0-c8aa08e4a3ca";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/f8fe8813-2ace-4004-89f0-a13487671a9d";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/389a549c-3a52-4667-bc09-b11a5ec06439";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptnix".device = "/dev/disk/by-uuid/f01ad6fa-7900-4fa9-9ab5-1761ef3d20e4";

  fileSystems."/nix/store" =
    { device = "/nix/store";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/a02122c0-0003-4dc8-bc5f-9d062ebf61b4";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptdata".device = "/dev/disk/by-uuid/fb963d9f-23c9-4a65-9fa3-d47d7691c390";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3130-1867";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
