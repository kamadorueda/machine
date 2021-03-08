#! /usr/bin/env bash

function main {
  nix-env --argstr flavor base --install --file  .
}

main "${@}"
