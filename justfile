set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

build:
  nixos-rebuild build

diff:
  nixos-rebuild dry-activate

gc:
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  nix-collect-garbage -d

niv *ARGS:
  niv -s src/sources/sources.json {{ARGS}}

switch:
  sudo nixos-rebuild switch \
    && find -L ~/.config/Code ~/.vscode \
      | while read -r path; do \
        path="$(readlink -f "${path}")" \
          && sudo chown "${USER}" "${path}" \
          && chmod +w "${path}"; \
    done

test:
  sudo nixos-rebuild test

td_latest := "https://repo2.timedoctor.com/td-desktop-hybrid/prod/latest-linux.yml"

update:
  @true \
    && just niv update homeManager --rev a6370ec40c8ed6e963093081c83f9982d532e49b \
    && just niv update niv \
    && just niv update nixpkgs \
    && just niv update nixpkgsNixos \
    && just niv update product \
    && td_version="$(curl -Ls {{td_latest}} | yq -r .version)" \
    && echo "Time Doctor version: ${td_version}" \
    && just niv update timedoctor -v "${td_version}" \
