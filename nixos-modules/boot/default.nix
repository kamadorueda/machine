{
  config,
  nixpkgs,
  ...
}:
let
  kernelPackages =
    let
      packages = nixpkgs.linuxPackages_latest;
    in
      builtins.trace "Linux kernel version: ${packages.kernel.version}"
      packages;
in {
  boot.kernelPackages = kernelPackages;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 60;
}
