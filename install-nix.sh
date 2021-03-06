# /usr/bin/env bash

set -o pipefail

function main {
  curl -L nixos.org/nix/install | sh
}

main "${@}"
