#! /bin/sh -eux

export GNUPGHOME="${PWD}/scripts/gpg-home"

secrets="${PWD}/secrets/machine.yaml"

rm -rf "${GNUPGHOME}"
mkdir -p "${GNUPGHOME}"
chmod 700 "${GNUPGHOME}"
gpgconf --kill gpg-agent

for email in kamadorueda@gmail.com; do
  echo "
    Key-Type: rsa
    Key-Usage: auth encrypt sign
    Expire-Date: 1m
    Name-Email: ${email}
    Name-Real: Kevin Amado
    %no-protection
    %commit
  " | gpg --generate-key --batch

  sops set "${secrets}" '["gpg"]'"[\"${email}\"]"'["public"]' \
    "$(jq --arg value "$(gpg --armor --export "${email}")" --exit-status --null-input '$value')"

  sops set "${secrets}" '["gpg"]'"[\"${email}\"]"'["private"]' \
    "$(jq --arg value "$(gpg --armor --export-secret-keys "${email}")" --exit-status --null-input '$value')"
done

rm -rf "${GNUPGHOME}"
