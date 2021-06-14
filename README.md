# My development machine, as code

1. Boot NixOS as explained in the
    [NixOS's download page](https://nixos.org/download).

1. Login as root.

1. Get your GitHub API token from the
    [secrets file](https://github.com/kamadorueda/secrets/blob/master/machine/secrets.sh)
    and export it into the terminal.

1. Install git with `nix-env -i git`.

1. Clone this repository:

    ```bash
          mkdir -p /home/kamadorueda/Documents/github/kamadorueda \
      &&  pushd /home/kamadorueda/Documents/github/kamadorueda \
        &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/machine" \
      &&  popd
    ```

1. Update your hardware configuration at `src/hardware/default.nix`
    with the results of: `nixos-generate-config --show-hardware-config`.

1. Rebuild with:

    ```bash
    NIX_PATH="nixos-config=/home/kamadorueda/Documents/github/kamadorueda/machine/configuration.nix:${NIX_PATH}" \
    nixos-rebuild switch
    ```

1. Logout and login as the new user.

1. Setup the state:

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
