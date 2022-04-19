#! /bin/sh -eu

sudo nix-env -p /nix/var/nix/profiles/system --set ./result
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot
