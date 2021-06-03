# shellcheck shell=bash

export MACHINE=~/Documents/github/kamadorueda/machine
export PRODUCT=~/Documents/gitlab/fluidattacks/product
export SECRETS=~/Documents/github/kamadorueda/secrets

for completion_script in ~/.nix-profile/share/bash-completion/completions/*
do
  source "${completion_script}"
done

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
  &&  nixpkgs-fmt "${MACHINE}" \
  &&  nix-env -iA packages.homeManager.home-manager -f "${MACHINE}" \
  &&  if test -v DEBUG
      then
        home-manager -A config -f "${MACHINE}" -n -v switch
      fi \
  &&  home-manager -A config -f "${MACHINE}" switch \
  &&  home-manager expire-generations "$(date +%Y-%m-%d)" \
  &&  source ~/.bashrc
}

function diffm {
  local current
  local next

      current="$(home-manager generations | tac | grep -Pom 1 '/nix/store/.*')" \
  &&  next="$(home-manager -A config -f "${MACHINE}" build)" \
  &&  diff --color=always --paginate --recursive --side-by-side "${current}" "${next}"
}

source "${SECRETS}/machine/secrets.sh"

export_fluid_aws_vars makes
# export_fluid_aws_vars integrates
# export_fluid_aws_vars skims

# dev_env integrates.back
dev_env skims
# dev_env melts
