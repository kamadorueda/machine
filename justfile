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
  @read -p 'Pess a key to continue...'
  sudo env "NIX_PATH=nixos-config=${PWD}/config.nix:${NIX_PATH}" \
    nixos-rebuild {{ARGS}}

td_latest := "https://repo2.timedoctor.com/td-desktop-hybrid/prod/latest-linux.yml"

update:
  just niv update homeManager
  just niv update nixpkgs
  just niv update nixpkgsNixos
  just niv update product
  td_version="$(curl -Ls {{td_latest}} | yq -r .version)"
  echo "Time Doctor version: ${td_version}"
  just niv update timedoctor -v "${td_version}"
