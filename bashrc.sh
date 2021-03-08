# shellcheck shell=bash

source ~/.nix-profile/etc/profile.d/nix.sh

alias today='git log --format=%aI --author kamado@fluidattacks.com | sed -E "s/T.*$//g" | uniq -c | head -n 7 | tac'
alias graph='TZ=UTC git rev-list --date=iso-local --pretty="!%H!!%ad!!%cd!!%aN!!%P!" --graph HEAD'
alias a='git add -p'
alias c='git commit --allow-empty'
alias f='git fetch --all'
alias l='git log'
alias m='git commit --amend --no-edit --allow-empty'
alias p='git push -f'
alias r='git pull --autostash --progress --rebase --stat origin master'
alias rp='r && p'
alias s='git status'

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
  &&  export PROD_AWS_ACCESS_KEY_ID="${!var}" \
  &&  for var in "${1^^}_DEV_AWS_SECRET_ACCESS_KEY" "${1^^}_PROD_AWS_SECRET_ACCESS_KEY"
      do use_fluid_var "${var}"
      done \
  &&  export AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export PROD_AWS_SECRET_ACCESS_KEY="${!var}"
}
