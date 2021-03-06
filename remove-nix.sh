# /usr/bin/env bash

function main {
  sudo rm -rf /nix/store
}

main "${@}"
