#! /bin/sh -eux

secrets="${PWD}/nixos-modules/sops/secrets.yaml"

cd secrets/ssh/

chmod 700 .
ssh-keygen -t ed25519 -C kamadorueda@gmail.com -f kamadorueda -N ''
ssh-add kamadorueda

sops set "${secrets}" '["ssh"]["kamadorueda"]["public"]' \
  "$(jq --rawfile value kamadorueda.pub --exit-status --null-input '$value')"

sops set "${secrets}" '["ssh"]["kamadorueda"]["private"]' \
  "$(jq --rawfile value kamadorueda --exit-status --null-input '$value')"

rm kamadorueda*
