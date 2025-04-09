#! /bin/sh -eux

pushd secrets/gpg/

rm -rf home
mkdir home
chmod 700 home
gpgconf --kill gpg-agent
