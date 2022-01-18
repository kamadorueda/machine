# shellcheck shell=bash

export DIRENV_WARN_TIMEOUT=1h
source "${SECRETS}/machine/secrets.sh"
ssh-add "${SECRETS}/machine/ssh/kamadorueda"
