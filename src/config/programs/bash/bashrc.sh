# shellcheck shell=bash

function dev_env {
  local code="${1}"

  cd "${PRODUCT}" \
    && source .envrc* \
    && CACHIX_FLUIDATTACKS_TOKEN= ./m "makes.dev.${code}" \
    && source "out/makes-dev-${code//./-}"
}

function export_fluid_var {
  export "${1}"="$(fetch_fluid_var ${1})"
}

function export_fluid_aws_vars {
  for var in "${1^^}_DEV_AWS_ACCESS_KEY_ID" "${1^^}_PROD_AWS_ACCESS_KEY_ID"; do
    export_fluid_var "${var}"
  done \
    && export AWS_ACCESS_KEY_ID="${!var}" \
    && export DEV_AWS_ACCESS_KEY_ID="${!var}" \
    && export PROD_AWS_ACCESS_KEY_ID="${!var}" \
    && for var in "${1^^}_DEV_AWS_SECRET_ACCESS_KEY" "${1^^}_PROD_AWS_SECRET_ACCESS_KEY"; do
      export_fluid_var "${var}"
    done \
    && export AWS_SECRET_ACCESS_KEY="${!var}" \
    && export DEV_AWS_SECRET_ACCESS_KEY="${!var}" \
    && export PROD_AWS_SECRET_ACCESS_KEY="${!var}"
}

function fetch_fluid_var {
  local url="https://gitlab.com/api/v4/projects/20741933/variables/${1}"

  echo "[INFO] Retrieving var from GitLab: ${1}" 1>&2 \
    && curl -s -H "private-token: ${GITLAB_API_TOKEN}" "${url}" | jq -r '.value'
}

source "${SECRETS}/machine/secrets.sh"

export_fluid_aws_vars makes
# export_fluid_aws_vars integrates
# export_fluid_aws_vars skims

# dev_env integrates.back
dev_env skims
# dev_env melts
