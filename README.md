# Kamadorueda's development machine, as code

1.  Make youre your system has `curl` installed

1.  Install nix as explained in the
    [Nix's download page](https://nixos.org/download):

    `$ curl -L nixos.org/nix/install | sh`

1.  Install with:

    `$ nix-env -if https://github.com/kamadorueda/machine/archive/main.tar.gz`

1.  Add the following line to your ~/.bashrc:

    `$ source ~/.nix-profile/etc/profile.d/bashrc`

1.  Install timedoctor as explained in the
    [Timedoctor's download page](https://www.timedoctor.com/es/download.html)

    This step is required to be done in the host as timedoctor
    is not compatible with Nix at the moment

# Aditional deployment steps for kamadorueda

Applies to myself only:

1.  Configure git:

    ```bash
    git config --global commit.gpgsign true
    git config --global init.defaultBranch main
    git config --global user.signingkey FFF341057F503148
    git config --global user.email kamadorueda@gmail.com
    git config --global user.name 'Kevin Amado'
    git config --global gpg.sign true
    git config --global gpg.progam gpg2
    ```

1.  Clone repositories:

    - `$ git clone https://kamadorueda:${GIHUB_API_TOKEN}@github.com/kamadorueda/secrets`
    - Perform secrets installation (mostly SSH and GPG keys)
    - `$ git clone git@github.com:kamadorueda/machine`
    - `$ git clone git@gitlab.com:fluidattacks/product`
