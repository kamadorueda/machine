# shellcheck shell=bash

function export_fluid_var {
  export "${1}"="$(fetch_fluid_var ${1})"
}

function export_fluid_aws_vars {
  : \
    && for var in \
      "DEV_${1^^}_AWS_ACCESS_KEY_ID" \
      "PROD_${1^^}_AWS_ACCESS_KEY_ID"; do
      export_fluid_var "${var}"
    done \
    && export AWS_ACCESS_KEY_ID="${!var}" \
    && export DEV_AWS_ACCESS_KEY_ID="${!var}" \
    && export PROD_AWS_ACCESS_KEY_ID="${!var}" \
    && for var in \
      "DEV_${1^^}_AWS_SECRET_ACCESS_KEY" \
      "PROD_${1^^}_AWS_SECRET_ACCESS_KEY"; do
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

export DIRENV_WARN_TIMEOUT=1h
source "${SECRETS}/machine/secrets.sh"
source <(m-comp-bash 2> /dev/null)
