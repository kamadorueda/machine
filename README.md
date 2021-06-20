# My development machine, as code

1. (Optional) if you want to dual-boot with Windows,
    install Windows first and then continue this tutorial.

1. Download `NixOS minimal ISO image` from the
    [NixOS's download page](https://nixos.org/download).

1. Burn it into a USB stick:

    ```bash
    lsblk
    device='/dev/xxx' # Replace by the correct one
    sudo umount "${device}"
    sudo dd conv=fdatasync if=nixos.iso of="${device}" status=progress
    ```

1. Boot from the USB stick, start the installation and then `sudo su`.

1. Create an empty partition where NixOS will live.

    Use the following commands as/if needed,
    replace "${device}" by the address of the main disk:

    - List block devices: `lsblk -fr`
    - Create a partition table: `parted "${device}" -- mktable gpt`
    - Remove a partition: `parted "${device}" -- rm "${number}"`

1. Setup the NixOS file system
    in the free space allocated in the previous step.

    ```bash
    # Print the current partitioning state
    parted "${device}" -- unit MiB print

    # Prepare boot device
    if in_dual_boot; then
      # Remove the Windows-managed boot partition
      parted "${device}" -- rm "${number}"
    fi
    parted "${device}" -- mkpart ESP fat32 "${start:-1MiB}" "${end:-512MiB}"
    parted "${device}" -- set "${number}" esp on
    mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/ESP

    # Prepare root device
    parted "${device}" -- mkpart primary "${start}" "${end:-100%}"
    cryptsetup luksFormat /dev/disk/by-partlabel/primary
    cryptsetup luksOpen /dev/disk/by-partlabel/primary cryptroot
    mkfs.ext4 -L nixos /dev/mapper/cryptroot

1. Finish NixOS installation:

    ```bash
    mount /dev/disk/by-label/nixos /mnt
    mkdir /mnt/boot
    mount /dev/disk/by-partlabel/ESP /mnt/boot
    nixos-generate-config --root /mnt
    cat << EOF >> /mnt/etc/nixos/configuration.nix
      // { boot.loader.efi.canTouchEfiVariables = true;
           boot.loader.systemd-boot.enable=true; }
    EOF
    nixos-install
    reboot
    ```

1. Clone this repository and rebuild:

    ```bash
    cd "$(mktemp -d)"
    nix-shell -p git
    git clone https://github.com/kamadorueda/machine
    cd machine
    nixos-generate-config --show-hardware-config > src/hardware/local.nix
    NIX_PATH="nixos-config=${PWD}/configuration.nix:${NIX_PATH}"
    nixos-rebuild switch
    reboot
    ```

1. Get your GitHub API token from the
    [secrets file](https://github.com/kamadorueda/secrets/blob/master/machine/secrets.sh)
    and export it into the terminal.

1. Setup the state:

    - github/kamadorueda/machine:

      ```bash
            mkdir -p /home/kamadorueda/Documents/github/kamadorueda \
        &&  pushd /home/kamadorueda/Documents/github/kamadorueda \
          &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/machine" \
        &&  popd
      ```

    - github/kamadorueda/secrets:

      ```bash
          mkdir -p ~/Documents/github/kamadorueda \
      &&  pushd ~/Documents/github/kamadorueda \
        &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/secrets" \
        &&  cd secrets/machine \
          &&  ./install.sh \
      &&  popd
      ```

    - gitlab/fluidattacks:

      ```bash
          mkdir -p ~/Documents/gitlab/fluidattacks \
      &&  pushd ~/Documents/gitlab/fluidattacks \
        &&  git clone git@gitlab.com:fluidattacks/product \
        &&  git clone git@gitlab.com:fluidattacks/services \
      &&  popd
      ```
1. Enjoy!

# Timedoctor

You may find useful to install [Timedoctor](https://www.timedoctor.com/)
via [Nix](https://nixos.org).

1. `$ nix-build -A packages.timedoctor https://github.com/kamadorueda/machine/archive/main.tar.gz`

2. `$ ./result/bin/timedoctor`

Source: [a8547c04](https://github.com/kamadorueda/machine/commit/a8547c048cfe34bc78475a8c8621b226426b81ab)

# Useful links

- [NixOS options](https://nixos.org/manual/nixos/stable/options.html)
- [NixOS options search](https://search.nixos.org/options)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)
