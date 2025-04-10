#! /usr/bin/env bash

set -euo pipefail

function file_to_json() {
  jq --rawfile value "${1}" --exit-status --null-input '$value'
}

ssh-keygen -t ed25519 -C kamadorueda@gmail.com -f kamadorueda -N ''
ssh-add kamadorueda

sops set secrets/machine.yaml \
  '["ssh"]["kamadorueda"]["public"]' \
  "$(file_to_json kamadorueda.pub)"

sops set secrets/machine.yaml \
  '["ssh"]["kamadorueda"]["private"]' \
  "$(file_to_json kamadorueda)"

rm kamadorueda*
