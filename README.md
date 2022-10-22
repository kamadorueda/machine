# My development machine, as code

This repository contains
everything that is needed
to create a clone of my operative system,
exactly as I use it every day.

This is roughly a [NixOS](https://nixos.org/) with four partitions:

- `/`, encrypted, ephemeral,
  [**erased** at every boot](https://grahamc.com/blog/erase-your-darlings).
- `/nix`, encrypted, persistent,
  but mounted as **read-only** for maximum immutability.
- `/data`, encrypted, persistent,
  and backed up regularly.
- `/boot`, an initial RAM disk to bootstrap the kernel and start the system.

This system has:

- The [latest stable Linux Kernel](https://www.kernel.org/),
  updated regularly to avoid running a system with [known publicly disclosed cybersecurity vulnerabilities](https://cve.mitre.org/).
- [Nvidia](https://www.nvidia.com/) drivers.
- [Multi-booting](https://en.wikipedia.org/wiki/Multi-booting) support.

In general, the system is made out of the following components:

- [books](./nixos-modules/books/default.nix):
  An eBook reader with the theme that I like.
- [browser](./nixos-modules/browser/default.nix):
  Web browser, extensions, and bookmarks.
- [editor](./nixos-modules/editor/default.nix):
  My code editor, extensions, theme, keyboard shortcuts, etc.
- [terminal](./nixos-modules/terminal/default.nix):
  My terminal configuration, shell aliases, installed packages,
  and so on.
- [ui](./nixos-modules/ui/default.nix):
  The window manager, fonts, and graphical elements.

- [buildkite](./nixos-modules/buildkite/default.nix):
  Some https://buildkite.com/ agents that run in my computer
  and serve as CI/CD of my open source projects.
- [k8s](./nixos-modules/k8s/default.nix):
  A Kubernetes cluster.
- [networking](./nixos-modules/networking/default.nix):
  Wifi settings, mostly.
- [nix](./nixos-modules/nix/default.nix):
  Configurations of the Nix daemon that powers this machine.
- [spark](./nixos-modules/spark/default.nix):
  An Apache Spark cluster.
- [virtualization](./nixos-modules/virtualization/default.nix):
  Containers, virtual machines and emulated architectures.

- [secrets](./nixos-modules/secrets/default.nix):
  SSH, GPG, system password and secrets locations.
- [users](./nixos-modules/users/default.nix):
  Admin and user accounts.
- [well-known](./nixos-modules/well-known/default.nix):
  Name, username and email of the main user.

- [controllers](./nixos-modules/controllers/default.nix):
  Kernel, drivers, firmware, and sound system.
- [physical](./nixos-modules/physical/default.nix):
  Boot loader and external devices identifiers (disks, swap, etc).

## Setup

1.  Download `NixOS minimal ISO image` from the
    [NixOS's download page](https://nixos.org/download).
    Or build from source code by cloning the repository and running:

    ```bash
    $ ./build-installer
    ```

1.  Burn it into a USB stick.

    - If you are currently on Windows use [Rufus](https://rufus.ie).

    - If you are on an unix-like operative system,
      you can do so from the command line:

      ```bash
      lsblk
      umount "${partition}"
      parted "${device}" -- mktable msdos
      dd bs=1MiB if="${iso}" of="${device}" oflag=direct status=progress
      ```

1.  (Optional)
    If you want to dual-boot with Windows,
    install Windows first
    on your whole disk.

    You'll get a partition scheme like this:

    ```
    Number Start    End      Size     File system  Name                          Flags
    1      0.00GiB  0.25GiB  0.25GiB  fat32        EFI system partition          boot, hidden, esp
    2      0.25GiB  0.27GiB  0.02GiB               Microsoft reserved partition  msftres
    3      0.27GiB  953GiB   953GiB   ntfs         Basic data partition          msftdata
    4      953GiB   954GiB   0.98GiB  ntfs         Basic data partition          hidden, diag
    ```

    All you need to do
    is to open `Disk Manager`
    on Windows,
    and resize the `msftdata` partition
    to make some free space for NixOS:

    ```
    Number Start    End      Size     File system  Name                          Flags
     1     0.00GiB  0.25GiB  0.25GiB  fat32        EFI system partition          boot, hidden, esp
     2     0.25GiB  0.27GiB  0.02GiB               Microsoft reserved partition  msftres
     3     0.27GiB  271GiB   271GiB   ntfs         Basic data partition          msftdata
     5     271GiB   953GiB   682GiB   -            -
     4     953GiB   954GiB   0.98GiB  ntfs         Basic data partition          hidden, diag
    ```

    After this tutorial
    you'll be able to pick
    which Operative System you want to use
    when the computer starts.

1.  Boot from the USB stick,
    start the installation
    and then `sudo su`.

    If for some reason
    your system refuses to boot into the USB,
    enter the BIOS and disable `Secure Boot`
    or try enabling `Legacy Boot` support.

1.  Make sure that we have
    some empty disk space for NixOS to live in.

    Use the following commands as needed,
    replace "${device}" by the address of the main disk:

    - List block devices: `lsblk -f`.
    - Managing partitions: `parted "${device}"`.
      - Create a partition table: `(parted) mktable gpt`.
      - Remove a partition: `(parted) rm "${number}"`.

1.  Setup the NixOS partition scheme
    in the free space allocated in the previous step.

    ```bash
    parted "${device}"

      # Generic setup
      (parted) unit GiB
      (parted) print

      # Setup boot partition
      (parted) mkpart ESP fat32 "${start}" "${end}" # 1GiB
      (parted) set "${number}" esp on

      # Setup other partitions
      (parted) mkpart data "${start}" "${end}" # At least 50 GiB
      (parted) mkpart root "${start}" "${end}" # At least 50 GiB
      (parted) mkpart nix "${start}" "${end}" # At least 100GiB
    ```

    It should look like this:

    ```
    Number  Start    End      Size     File system  Name                          Flags
     1      0.00GiB  0.25GiB  0.25GiB  fat32        EFI system partition          boot, hidden, esp
     2      0.25GiB  0.27GiB  0.02GiB               Microsoft reserved partition  msftres
     3      0.27GiB  271GiB   271GiB   ntfs         Basic data partition          msftdata
     5      271GiB   272GiB   0.68GiB  fat32        ESP                           boot, esp
     6      272GiB   322GiB   50.0GiB               data
     7      322GiB   372GiB   50.0GiB               root
     8      372GiB   953GiB   581GiB                nix
     4      953GiB   954GiB   0.98GiB  ntfs         Basic data partition          hidden, diag
    ```

    The Windows partitions (1, 2, 3 and 4) are optional
    if you do not want to dual boot with Windows.

1.  Encrypt disks with LUKS:

    ```bash
    cryptsetup luksFormat /dev/disk/by-partlabel/data
    cryptsetup luksFormat /dev/disk/by-partlabel/nix
    cryptsetup luksFormat /dev/disk/by-partlabel/root
    cryptsetup luksOpen /dev/disk/by-partlabel/data cryptdata
    cryptsetup luksOpen /dev/disk/by-partlabel/nix cryptnix
    cryptsetup luksOpen /dev/disk/by-partlabel/root cryptroot

    mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/ESP
    mkfs.ext4 -L data /dev/mapper/cryptdata
    mkfs.ext4 -L nix /dev/mapper/cryptnix
    mkfs.ext4 -L root /dev/mapper/cryptroot
    ```

1.  Install NixOS, step one:

    ```bash
    mount /dev/disk/by-label/root /mnt
    mkdir /mnt/boot
    mkdir /mnt/data
    mkdir /mnt/nix
    mount /dev/disk/by-partlabel/ESP /mnt/boot
    mount /dev/disk/by-label/data /mnt/data
    mount /dev/disk/by-label/nix /mnt/nix

    nixos-generate-config --root /mnt
    cat << EOF >> /mnt/etc/nixos/configuration.nix
      // {  boot.kernelPackages = pkgs.linuxPackages_latest;
            environment.systemPackages = [ pkgs.wpa_supplicant ];
            hardware.enableAllFirmware = true;
            nixpkgs.config.allowUnfree = true;
            services.nscd.enable = true; }
    EOF
    if not_connected_to_the_internet; then
      ip a
      wpa_supplicant -B -i "${interface}" -c <(wpa_passphrase "${ssid}" "{psk}")
    fi
    nixos-install
    reboot
    ```

1.  Install NixOS, step two:

    ```bash
    if not_connected_to_the_internet; then
      ip a
      wpa_supplicant -B -i "${interface}" -c <(wpa_passphrase "${ssid}" "{psk}")
    fi
    cd "$(mktemp -d)"
    nix-shell -p git just
    git clone https://github.com/kamadorueda/machine
    cd machine
    ./build-system
    ./switch-to-configuration
    reboot
    ```

1.  Enjoy!

## Nvidia

1.  Look up your graphics card product:

    ```bash
    $ nix shell nixpkgs#pciutils

    [nix-shell] $ lspci

    # ...
    01:00.0 VGA compatible controller: NVIDIA Corporation TU116 [GeForce GTX 1660] (rev a1)
    # ...
    ```

1.  See which is the highest driver version
    that supports your product:
    https://www.nvidia.com/en-us/drivers/unix/

1.  Map it to a package in
    [nixpkgs](https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix):

    You can also explore:
    `nixpkgs.linuxPackages_latest.nvidiaPackages.*.version`
    on a `$ nix repl`.

1.  Add it to your configuration.

    You can see the `hardware` NixOS module in this repository for an example.

1.  Switch and reboot.

1.  Should be in use now:

    ```bash
    $ nix run nixpkgs#glxinfo -- -B

    # ...
    OpenGL vendor string: NVIDIA Corporation
    # ...
    ```

    It should not mention [nouveau](https://nouveau.freedesktop.org/)
    but [Nvidia](https://www.nvidia.com/).

## Useful links

- [NixOS options](https://nixos.org/manual/nixos/stable/options.html)
- [NixOS options search](https://search.nixos.org/options)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)

## Future work

All good for now.
