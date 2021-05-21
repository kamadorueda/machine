# shellcheck shell=bash

export MACHINE_PROFILE=~/.nix-profile
export MACHINE_STATE_DIR=~/Documents/.state
export CODE_USER_DATA_DIR="${MACHINE_STATE_DIR}/code"
export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ";

alias today='git log --format=%aI --author kamado@fluidattacks.com | sed -E "s/T.*$//g" | uniq -c | head -n 7 | tac'
alias graph='TZ=UTC git rev-list --date=iso-local --pretty="!%H!!%ad!!%cd!!%aN!!%P!" --graph HEAD'
alias a='git add -p'
alias c='git commit --allow-empty'
alias cm='git log -n 1 --format=%s%n%n%b'
alias code='code --user-data-dir "${CODE_USER_DATA_DIR}"'
alias cr='git commit -m "$(cm)"'
alias f='git fetch --all'
alias l='git log --show-signature'
alias m='git commit --amend --no-edit --allow-empty'
alias melts='CI=true CI_COMMIT_REF_NAME=master melts'
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
  &&  export DEV_AWS_ACCESS_KEY_ID="${!var}" \
  &&  export PROD_AWS_ACCESS_KEY_ID="${!var}" \
  &&  for var in "${1^^}_DEV_AWS_SECRET_ACCESS_KEY" "${1^^}_PROD_AWS_SECRET_ACCESS_KEY"
      do use_fluid_var "${var}"
      done \
  &&  export AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export DEV_AWS_SECRET_ACCESS_KEY="${!var}" \
  &&  export PROD_AWS_SECRET_ACCESS_KEY="${!var}"
}

function configure_code {
  local config_path="${CODE_USER_DATA_DIR}/User/settings.json"

      mkdir -p "$(dirname "${config_path}")" \
  &&  echo '{
        "[html]": {
          "editor.formatOnSave": false
        },
        "editor.formatOnSave": true,
        "editor.rulers": [
          80
        ],
        "extensions.autoUpdate": false,
        "files.insertFinalNewline": true,
        "files.trimFinalNewlines": true,
        "files.trimTrailingWhitespace": true,
        "python.defaultInterpreterPath": "/home/kamado/.nix-profile/bin/python",
        "python.formatting.blackArgs": [
          "--config",
          "/home/kamado/.nix-profile/product/makes/utils/python-format/settings-black.toml"
        ],
        "python.formatting.blackPath": "/home/kamado/.nix-profile/bin/black",
        "python.formatting.provider": "black",
        "python.languageServer": "Pylance",
        "python.linting.enabled": true,
        "python.linting.lintOnSave": true,
        "python.linting.mypyArgs": [
          "--config-file",
          "/home/kamado/.nix-profile/product/makes/utils/lint-python/settings-mypy.cfg"
        ],
        "python.linting.mypyEnabled": true,
        "python.linting.prospectorArgs": [
          "--profile",
          "/home/kamado/.nix-profile/product/makes/utils/lint-python/settings-prospector.yaml"
        ],
        "python.linting.prospectorEnabled": true,
        "python.linting.pylintEnabled": false,
        "telemetry.enableTelemetry": false,
        "update.mode": "none",
        "window.zoomLevel": 2,
        "workbench.startupEditor": "none",
        "workbench.editor.enablePreview": false
      }' | jq > "${config_path}"
}

eval "$(direnv hook bash)"
configure_code

source ~/Documents/github/kamadorueda/secrets/machine/secrets.sh

    cd ~/Documents/gitlab/fluidattacks/product \
&&  source .envrc* \
&&  CACHIX_FLUIDATTACKS_TOKEN= ./m makes.dev.skims \
&&  source out/makes-dev-skims
