set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

gc:
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  nix-collect-garbage -d
  nix-store --optimise

niv *ARGS:
  niv -s src/sources/sources.json {{ARGS}}

rebuild *ARGS:
  nixos-generate-config --show-hardware-config | tee src/hardware/local.nix
  @echo
  @read -N 1 -p 'Pess a key to continue...' -r
  sudo env "NIX_PATH=nixos-config=${PWD}/config.nix:${NIX_PATH}" \
    nixos-rebuild {{ARGS}}

td_latest := "https://repo2.timedoctor.com/td-desktop-hybrid/prod/latest-linux.yml"

update:
  @echo Updating homeManager
  just niv update homeManager

  @echo Updating makes
  just niv update makes

  @echo Updating nixpkgs
  just niv update nixpkgs

  @echo Updating nixpkgsNixos
  just niv update nixpkgsNixos

  @echo Updating product
  just niv update product

  @echo Updating timedoctor
  td_version="$(curl -Ls {{td_latest}} | yq -r .version)" \
    && echo "Time Doctor version: ${td_version}" \
    && just niv update timedoctor -v "${td_version}"
