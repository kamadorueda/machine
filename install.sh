# /usr/bin/env bash

function main {
  nix-env -if .
}

main "${@}"
