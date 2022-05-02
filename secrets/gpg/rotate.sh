#! /bin/sh -eux

pushd secrets/gpg/

rm -rf home
mkdir home
chmod 700 home
gpgconf --kill gpg-agent

cat | gpg --generate-key --batch << EOF
Key-Type: rsa
Key-Usage: auth encrypt sign
Expire-Date: 1m
Name-Email: kamadorueda@gmail.com
Name-Real: Kevin Amado
%no-protection
%commit
EOF
gpg --list-secret-keys --keyid-format=long

read -p "id> " id

echo "${id}" > gpg.id
gpg --armor --export "${id}" > gpg.pub
gpg --armor --export-secret-keys "${id}" > gpg
