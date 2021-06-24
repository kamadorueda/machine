# My development machine, as code

- Powered by [NixOS](https://nixos.org/) and four partitions:
  - `/`, ephemeral, **deleted** at EVERY boot
  - `/boot`
  - `/data`, persistent, where my important data lives in
  - `/nix`, persistent, but mounted as **read-only**

## Setup

1. (Optional) if you want to dual-boot with Windows,
    install Windows first and then continue this tutorial.

1. Download `NixOS minimal ISO image` from the
    [NixOS's download page](https://nixos.org/download).

1. Burn it into a USB stick:

    ```bash
    lsblk
    umount "${partition}"
    parted "${device}" -- mktable msdos
    dd bs=1MiB if="${iso}" of="${device}" oflag=direct status=progress
    ```

1. Boot from the USB stick, start the installation and then `sudo su`.

1. Allocate some empty disk space for NixOS to live in.

    Use the following commands as/if needed,
    replace "${device}" by the address of the main disk:

    - List block devices: `lsblk -fr`
    - Managing partitions: `parted "${device}"`
      - Create a partition table: `(parted) mktable gpt`
      - Remove a partition: `(parted) rm "${number}"`

1. Setup the NixOS file system
    in the free space allocated in the previous step.

    ```bash
    parted "${device}"

      # Generic setup
      (parted) unit MiB
      (parted) print

      # Setup boot partition
      (parted) rm "${number}" # Remove existing boot partitions
      (parted) mkpart ESP fat32 "${start:-1MiB}" "${end:-512MiB}"
      (parted) set "${number}" esp on

      # Setup other partitions
      (parted) mkpart data "${start}" "${end}"
      (parted) mkpart nix "${start}" "${end}"
      (parted) mkpart root "${start}" "${end}"
    ```

1. Finish NixOS installation:

    ```bash
    cryptsetup luksFormat /dev/disk/by-partlabel/data
    cryptsetup luksFormat /dev/disk/by-partlabel/nix
    cryptsetup luksFormat /dev/disk/by-partlabel/root
    cryptsetup luksOpen /dev/disk/by-partlabel/data cryptdata
    cryptsetup luksOpen /dev/disk/by-partlabel/nix cryptnix
    cryptsetup luksOpen /dev/disk/by-partlabel/root cryptroot

    mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/ESP
    mkfs.ext4 -L nix /dev/mapper/cryptnix
    mkfs.ext4 -L data /dev/mapper/cryptdata
    mkfs.ext4 -L root /dev/mapper/cryptroot

    mount /dev/disk/by-label/root /mnt
    mkdir /mnt/boot
    mount /dev/disk/by-partlabel/ESP /mnt/boot
    mount /dev/disk/by-label/data /mnt/data
    mount /dev/disk/by-label/nix /mnt/nix

    nixos-generate-config --root /mnt
    cat << EOF >> /mnt/etc/nixos/configuration.nix
      // { boot.loader.efi.canTouchEfiVariables = true;
           boot.loader.systemd-boot.enable = true;
           environment.systemPackages = [ pkgs.wpa_supplicant ];
           services.nscd.enable = true; }
    EOF
    if not_connected_to_the_internet; then
      ip a # List interfaces
      wpa_supplicant -B -i "${interface}" -c <(wpa_supplicant "${ssid}" "{psk}")
    fi
    nixos-install
    reboot
    ```

1. Clone this repository and rebuild:

    ```bash
    cd "$(mktemp -d)"
    nix-shell -p git just
    git clone https://github.com/kamadorueda/machine
    cd machine
    just rebuild switch
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

## Timedoctor

You may find useful to install [Timedoctor](https://www.timedoctor.com/)
via [Nix](https://nixos.org).

1. `$ NIXPKGS_ALLOW_UNFREE=1 nix-build -A timedoctor https://github.com/nixos/nixpkgs/archive/7310407d493ee1c7caf38f8181507d7ac9c90eb8.tar.gz`

2. `$ ./result/bin/timedoctor*`

Source: [Pull 127590](https://github.com/NixOS/nixpkgs/pull/127590)

## Useful links

- [NixOS options](https://nixos.org/manual/nixos/stable/options.html)
- [NixOS options search](https://search.nixos.org/options)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)
