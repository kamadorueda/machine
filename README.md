# My development machine, as code

1.  Make sure your system has `curl` installed

1.  Install nix as explained in the
    [Nix's download page](https://nixos.org/download):

    ```bash
    curl -L nixos.org/nix/install | sh
    ```

1. Get your GitHub API token from the
    [secrets file](https://github.com/kamadorueda/secrets/blob/master/machine/secrets.sh)
    and export it into the terminal

1. Execute:

    ```bash
        src='https://github.com/kamadorueda/machine/archive/refs/heads/main.tar.gz' \
    &&  nix-env -iA packages.homeManager.home-manager -f "${src}" \
    &&  home-manager -A config -f "${src}" switch \
    &&  source ~/.bashrc
    ```

1. Setup the state:

    - github/kamadorueda/secrets:

      ```bash
          mkdir -p ~/Documents/github/kamadorueda \
      &&  pushd ~/Documents/github/kamadorueda \
        &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/secrets" \
        &&  cd secrets/machine \
          &&  install.sh \
      &&  popd
      ```

    - github/kamadorueda/machine:

      ```bash
          mkdir -p ~/Documents/github/kamadorueda \
      &&  pushd ~/Documents/github/kamadorueda \
        &&  git clone git@github.com:kamadorueda/machine \
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

# Notes to myself

- Update all sources: `$ nix3 flake update`
