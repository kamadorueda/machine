#! /usr/bin/env bash

set -euo pipefail

agent="${1:-}"
shift

case "${agent}" in
  public) ;;
  private) ;;
  *)
    echo "Only public and private are supported"
    exit 1
    ;;
esac

export SOPS_AGE_KEY
SOPS_AGE_KEY="$(
  sops decrypt --extract "[\"buildkite-${agent}-age-key\"]" secrets/machine.yaml
)"
export SOPS_AGE_RECIPIENTS
SOPS_AGE_RECIPIENTS="$(echo "${SOPS_AGE_KEY}" | age-keygen -y)"

"${@}"
