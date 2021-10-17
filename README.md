# My development machine, as code

- Powered by [NixOS](https://nixos.org/) and four partitions:
  - `/`, ephemeral, **deleted** at EVERY boot
  - `/boot`
  - `/data`, persistent, where my important data lives in
  - `/nix`, persistent, but mounted as **read-only**

## Setup

1.  (Optional) if you want to dual-boot with Windows,
    install Windows first and then continue this tutorial.

1.  Download `NixOS minimal ISO image` from the
    [NixOS's download page](https://nixos.org/download).

1.  <details>
      <summary>Burn it into a USB stick.</summary>

      - If you are currently on Windows use [Rufus](https://rufus.ie)

      - If you are on an unix-like operative system:

        ```bash
        lsblk
        umount "${partition}"
        parted "${device}" -- mktable msdos
        dd bs=1MiB if="${iso}" of="${device}" oflag=direct status=progress
        ```
    </details>

1.  Boot from the USB stick, start the installation and then `sudo su`.

1.  <details>
      <summary>Allocate some empty disk space for NixOS to live in.</summary>
      Use the following commands as needed,
      replace "${device}" by the address of the main disk:

      - List block devices: `lsblk -f`
      - Managing partitions: `parted "${device}"`
        - Create a partition table: `(parted) mktable gpt`
        - Remove a partition: `(parted) rm "${number}"`
    </details>

1.  <details>
      <summary>Setup the NixOS file system
      in the free space allocated in the previous step.</summary>

      ```bash
      parted "${device}"

        # Generic setup
        (parted) unit GiB
        (parted) print

        # Setup boot partition
        (parted) rm "${number}" # Remove existing boot partitions
        (parted) mkpart ESP fat32 1MiB 0.5
        (parted) set "${number}" esp on

        # Setup other partitions
        (parted) mkpart data "${start}" "${end}" # 50 GiB
        (parted) mkpart nix "${start}" "${end}" # 100 GiB
        (parted) mkpart root "${start}" "${end}" # 50 GiB
      ```
    </details>

1.  <details>
      <summary>Finish NixOS installation.</summary>

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

      mount /dev/disk/by-label/root /mnt
      mkdir /mnt/boot
      mkdir /mnt/data
      mkdir /mnt/nix
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
        ip a
        wpa_supplicant -B -i "${interface}" -c <(wpa_passphrase "${ssid}" "{psk}")
      fi
      nixos-install
      reboot
      ```
    </details>

1.  <details>
      <summary>Clone this repository and rebuild.</summary>

      ```bash
      if not_connected_to_the_internet; then
        ip a
        wpa_supplicant -B -i "${interface}" -c <(wpa_passphrase "${ssid}" "{psk}")
      fi
      cd "$(mktemp -d)"
      nix-shell -p git just
      git clone https://github.com/kamadorueda/machine
      cd machine
      just rebuild switch
      reboot
      ```
    </details>

1. Get your GitHub API token from the
    [secrets file](https://github.com/kamadorueda/secrets/blob/master/machine/secrets.sh)
    and export it into the terminal.

1.  <details>
      <summary>Setup the state.</summary>

      - <details>
          <summary>github/kamadorueda/machine</summary>

          ```bash
                mkdir -p /data/github/kamadorueda \
            &&  pushd /data/github/kamadorueda \
              &&  git clone "https://kamadorueda:${GITHUB_API_TOKEN}@github.com/kamadorueda/machine" \
            &&  popd
          ```
        </details>

      - <details>
          <summary>github/kamadorueda/secrets</summary>

          ```bash
              mkdir -p /data/github/kamadorueda \
          &&  pushd /data/github/kamadorueda \
            &&  git clone --depth 1 "https://kamadorueda:${GITHUB_API_TOKEN}@github.com/kamadorueda/secrets" \
            &&  cd secrets/machine \
              &&  ./install.sh \
          &&  popd
          ```
        </details>

      - <details>
          <summary>github/kamadorueda/nixpkgs-python</summary>

          ```bash
                mkdir -p /data/github/kamadorueda \
          &&  pushd /data/github/kamadorueda \
            &&  git clone git@github.com:kamadorueda/nixpkgs-python \
          &&  popd
          ```
        </details>

      - <details>
          <summary>github/fluidattacks</summary>

          ```bash
              mkdir -p /data/github/kamadorueda \
          &&  pushd /data/github/kamadorueda \
            &&  git clone git@github.com:kamadorueda/makes \
            &&  git -C makes remote add upstream git@github.com:fluidattacks/makes \
          &&  popd
          ```
        </details>

      - <details>
          <summary>github/nixos</summary>

          ```bash
              mkdir -p /data/github/kamadorueda \
          &&  pushd /data/github/kamadorueda \
            &&  git clone git@github.com:kamadorueda/nixpkgs \
            &&  git -C nixpkgs remote add upstream git@github.com:nixos/nixpkgs \
          &&  popd
          ```
        </details>

      - <details>
          <summary>gitlab/fluidattacks</summary>

          ```bash
              mkdir -p /data/gitlab/fluidattacks \
          &&  pushd /data/gitlab/fluidattacks \
            &&  git clone git@gitlab.com:fluidattacks/product \
            &&  git -C product config user.email kamado@fluidattacks.com \
            &&  git clone git@gitlab.com:fluidattacks/services \
            &&  git -C services config user.email kamado@fluidattacks.com \
          &&  popd
          ```
        </details>
    </details>

1. Enjoy!

## Timedoctor

You may find useful to install [Timedoctor](https://www.timedoctor.com/)
via [Nix](https://nixos.org).

1. `$ NIXPKGS_ALLOW_UNFREE=1 nix-build -A timedoctor https://github.com/nixos/nixpkgs/archive/7310407d493ee1c7caf38f8181507d7ac9c90eb8.tar.gz`

2. `$ ./result/bin/timedoctor*`

Source: [Pull 127590](https://github.com/NixOS/nixpkgs/pull/127590)

Caveats:
- It does not work with Gnome Display Manager (gdm), use LightDM (lightdm)
- It only works with X.org server, not Wayland, etc.

## Useful links

- [NixOS options](https://nixos.org/manual/nixos/stable/options.html)
- [NixOS options search](https://search.nixos.org/options)
- [Home Manager options](https://nix-community.github.io/home-manager/options.html)

## Future work

All good for now
