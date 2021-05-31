# shellcheck shell=bash

export MACHINE=~/Documents/github/kamadorueda/machine
export PRODUCT=~/Documents/gitlab/fluidattacks/product
export SECRETS=~/Documents/github/kamadorueda/secrets

export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ";

function dev_env {
  local code="${1}"

      cd "${PRODUCT}" \
  &&  source .envrc* \
  &&  CACHIX_FLUIDATTACKS_TOKEN= ./m "makes.dev.${code}" \
  &&  source "out/makes-dev-${code//./-}"
}

function export_fluid_var {
  export "${1}"="$(fetch_fluid_var ${1})"
}

function export_fluid_aws_vars {
      for var in "${1^^}_DEV_AWS_ACCESS_KEY_ID" "${1^^}_PROD_AWS_ACCESS_KEY_ID"
      do export_fluid_var "${var}"
      done \
  &&  export AWS_ACCESS_KEY_ID="${!var}" \
  &&  export DEV_AWS_ACCESS_KEY_ID="${!var}" \
  &&  export PROD_AWS_ACCESS_KEY_ID="${!var}" \
  &&  for var in "${1^^}_DEV_AWS_SECRET_ACCESS_KEY" "${1^^}_PROD_AWS_SECRET_ACCESS_KEY"
      do export_fluid_var "${var}"
      done \
  &&  export AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export DEV_AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export PROD_AWS_SECRET_ACCESS_KEY="${!var}"
}

function fetch_fluid_var {
  local url="https://gitlab.com/api/v4/projects/20741933/variables/${1}"

      echo "[INFO] Retrieving var from GitLab: ${1}" 1>&2 \
  &&  curl -s -H "private-token: ${GITLAB_API_TOKEN}" "${url}" | jq -r '.value'
}

function switch {
      clear \
  &&  cd "${MACHINE}" \
  &&  nixpkgs-fmt . \
  &&  nix-env -iA packages.homeManager.home-manager -f . \
  &&  home-manager -A config -f . -n -v switch \
  &&  home-manager -A config -f . switch \
  &&  home-manager expire-generations "$(date +%Y-%m-%d)" \
  &&  source ~/.bashrc
}

source "${SECRETS}/machine/secrets.sh"

# export_fluid_aws_vars integrates
# dev_env integrates.back

# export_fluid_aws_vars skims
dev_env skims

export_fluid_aws_vars makes
