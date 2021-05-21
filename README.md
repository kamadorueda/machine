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
        nix-env -i git \
    &&  mkdir -p ~/Documents/github/kamadorueda \
    &&  pushd    ~/Documents/github/kamadorueda \
      &&  git clone "https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/secrets" \
      &&  pushd secrets/machine \
        &&  install.sh \
      &&  popd \
      &&  git clone git@github.com:kamadorueda/machine \
      &&  pushd machine \
        &&  nix-env -e git \
        &&  nix-env -if ./home-manager.nix \
        &&  home-manager -f ./home.nix switch \
      &&  popd \
    &&  popd \
    &&  mkdir -p ~/Documents/gitlab/fluidattacks \
    &&  pushd    ~/Documents/gitlab/fluidattacks \
      &&  git clone git@gitlab.com:fluidattacks/product \
    &&  popd
    ```

1.  Install Timedoctor as explained in the
    [Timedoctor's download page](https://www.timedoctor.com/es/download.html)

    This step is required to be done in the host as timedoctor
    is not compatible with Nix at the moment
