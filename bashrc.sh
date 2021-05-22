# shellcheck shell=bash

export MACHINE=~/Documents/github/kamadorueda/machine
export PRODUCT=~/Documents/gitlab/fluidattacks/product
export SECRETS=~/Documents/github/kamadorueda/secrets

export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ";

function fetch_fluid_var {
  export CI_PROJECT_ID='20741933'
  local url="https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/variables/${1}"

      echo "[INFO] Retrieving var from GitLab: ${1}" 1>&2 \
  &&  curl -s -H "private-token: ${GITLAB_API_TOKEN}" "${url}" | jq -r '.value'
}

function use_fluid_var {
  export "${1}"="$(fetch_fluid_var ${1})"
}

function use_fluid_aws_var {
      for var in "${1^^}_DEV_AWS_ACCESS_KEY_ID" "${1^^}_PROD_AWS_ACCESS_KEY_ID"
      do use_fluid_var "${var}"
      done \
  &&  export AWS_ACCESS_KEY_ID="${!var}" \
  &&  export DEV_AWS_ACCESS_KEY_ID="${!var}" \
  &&  export PROD_AWS_ACCESS_KEY_ID="${!var}" \
  &&  for var in "${1^^}_DEV_AWS_SECRET_ACCESS_KEY" "${1^^}_PROD_AWS_SECRET_ACCESS_KEY"
      do use_fluid_var "${var}"
      done \
  &&  export AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export DEV_AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export PROD_AWS_SECRET_ACCESS_KEY="${!var}"
}

function home_switch {
      cd "${MACHINE}" \
  &&  nix-env -if home-manager.nix \
  &&  home-manager -f home.nix switch
}

source "${SECRETS}/machine/secrets.sh"

    cd "${PRODUCT}" \
&&  source .envrc* \
&&  CACHIX_FLUIDATTACKS_TOKEN= ./m makes.dev.skims \
&&  source out/makes-dev-skims
