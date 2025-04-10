export PAGER=

if test "${BUILDKITE_BRANCH}" != main; then
  echo ERROR: This agent only supports being run from a main branch.
  exit 1
fi

case "${BUILDKITE_PIPELINE_NAME}" in
  alejandra)
    export CACHIX_AUTH_TOKEN="${CACHIX_AUTH_TOKEN_ALEJANDRA}"
    export COVERALLS_REPO_TOKEN="${COVERALLS_KAMADORUEDA_ALEJANDRA}"
    ;;
  nixel)
    export COVERALLS_REPO_TOKEN="${COVERALLS_KAMADORUEDA_NIXEL}"
    ;;
  santiago)
    export COVERALLS_REPO_TOKEN="${COVERALLS_KAMADORUEDA_SANTIAGO}"
    ;;
  toros)
    export COVERALLS_REPO_TOKEN="${COVERALLS_KAMADORUEDA_TOROS}"
    ;;
  *)
    echo ERROR: Unsupported pipeline: "${BUILDKITE_PIPELINE_NAME}"
    exit 1
    ;;
esac
