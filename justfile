set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

build:
  nixos-rebuild build

diff:
  nixos-rebuild dry-activate

switch:
  sudo nixos-rebuild switch

test:
  sudo nixos-rebuild test

td_latest := "https://repo2.timedoctor.com/td-desktop-hybrid/prod/latest-linux.yml"


update:
  @td_version="$(curl -Ls {{td_latest}} | yq -r .version)" \
    && echo "Time Doctor version: ${td_version}" \
    && niv -s src/sources/sources.json update timedoctor -v "${td_version}" \
    && niv -s src/sources/sources.json update \
