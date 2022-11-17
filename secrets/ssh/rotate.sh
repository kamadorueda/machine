#! /bin/sh -eux

cd secrets/ssh/

chmod 700 .
rm kamadorueda*
rm kevinatholdings*
ssh-keygen -t ed25519 -C kamadorueda@gmail.com -f kamadorueda
ssh-keygen -t ed25519 -C kevin@holdings.io -f kevinatholdings
ssh-add kamadorueda
ssh-add kevinatholdings
