#! /bin/sh -eux

cd secrets/ssh/

chmod 600 kamadorueda*

if test -n "${WSL_DISTRO_NAME:-}"; then
  rm -rf ~/.ssh/
  mkdir -p ~/.ssh/
  cp kamadorueda* ~/.ssh/ 
  chmod 600 ~/.ssh/kamadorueda*
  {
    echo 'Host github.com'
    echo '  HostName github.com'
    echo '  IdentityFile ~/.ssh/kamadorueda'
  } > ~/.ssh/config
fi
