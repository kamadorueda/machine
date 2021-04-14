# Kamadorueda's development machine, as code

1.  Make youre your system has `curl` installed

1.  Install nix as explained in the
    [Nix's download page](https://nixos.org/download):

    `$ curl -L nixos.org/nix/install | sh`

1.  Install with:

    `$ nix-env -if https://github.com/kamadorueda/machine/archive/main.tar.gz`

1.  Add the following line to your ~/.bashrc:

    `$ source ~/.nix-profile/etc/profile.d/bashrc`

1.  Install timedoctor as explain in the
    [Timedoctor's download page](https://www.timedoctor.com/es/download.html)