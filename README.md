# My development machine, as code

1.  Make sure your system has `curl` installed

1.  Install nix as explained in the
    [Nix's download page](https://nixos.org/download):

    ```bash
    curl -L nixos.org/nix/install | sh
    ```

1. Execute:

    ```bash
        src='https://github.com/kamadorueda/machine/archive/refs/heads/main.tar.gz' \
    &&  nix-env -iA packages.homeManager.home-manager -f "${src}" \
    &&  home-manager -A config -f "${src}" switch \
    &&  source ~/.bashrc
    ```

1. Get your GitHub API token from the
    [secrets file](https://github.com/kamadorueda/secrets/blob/master/machine/secrets.sh)
    and export it into the terminal

1. Setup the state:

    ```bash
        pushd ~/Documents
      &&  mkdir -p github/kamadorueda \
      &&  pushd github/kamadorueda \
        &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/secrets" \
        &&  pushd secrets/machine \
          &&  install.sh \
        &&  popd \
        &&  git clone git@github.com:kamadorueda/machine \
      &&  popd \
      &&  mkdir -p gitlab/fluidattacks \
      &&  pushd gitlab/fluidattacks \
        &&  git clone git@gitlab.com:fluidattacks/product \
        &&  git clone git@gitlab.com:fluidattacks/services \
      &&  popd \
    &&  popd
    ```
