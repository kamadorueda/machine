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
  nix-store --optimise

niv *ARGS:
  niv -s src/sources/sources.json {{ARGS}}

switch:
  sudo env "NIX_PATH=${NIX_PATH}" nixos-rebuild switch \
    && just switch-writeable

switch-writeable:
  find -L ~/.config/Code ~/.vscode \
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
    && just niv update homeManager \
    && just niv update niv \
    && just niv update nixpkgs \
    && just niv update nixpkgsNixos \
    && just niv update product \
    && td_version="$(curl -Ls {{td_latest}} | yq -r .version)" \
    && echo "Time Doctor version: ${td_version}" \
    && just niv update timedoctor -v "${td_version}" \
