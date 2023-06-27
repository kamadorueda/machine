#! /bin/sh -eux

cd secrets/ssh/

chmod 700 .
rm kamadorueda*
ssh-keygen -t ed25519 -C kamadorueda@gmail.com -f kamadorueda
ssh-add kamadorueda
