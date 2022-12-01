#! /bin/sh -eux

cd secrets/gpg/

rm -rf home
mkdir home
chmod 700 home
gpgconf --kill gpg-agent

for email in kamadorueda@gmail.com; do
  cat | gpg --generate-key --batch << EOF
Key-Type: rsa
Key-Usage: auth encrypt sign
Expire-Date: 1m
Name-Email: ${email}
Name-Real: Kevin Amado
%no-protection
%commit
EOF
  gpg --list-secret-keys --keyid-format=long

  read -p "id> " id

  echo "${id}" > "gpg-${email}.id"
  gpg --armor --export "${id}" > "gpg-${email}.pub"
  gpg --armor --export-secret-keys "${id}" > "gpg-${email}"
done
