{ config
, nixpkgs
, ...
}:
{
  virtualisation.oci-containers.containers = builtins.foldl' (
    result: repo: result
    // (
      let
        name = builtins.replaceStrings [ "/" ] [ "-" ] repo;
      in
        {
          "github-runner-${name}" = rec {
            image = "myoung34/github-runner:latest";
            environment = {
              CONFIGURED_ACTIONS_RUNNER_FILES_DIR = "/var/run/github-runner/${name}-state";
              REPO_URL = "https://github.com/${repo}";
              RUNNER_NAME = name;
              RUNNER_WORKDIR = "/var/run/github-runner/${name}-workdir";
            };
            environmentFiles = [
              "${config.secrets.path}/machine/secrets.env"
            ];
            volumes =
              with environment;
              [
                # "/var/run/docker.sock:/var/run/docker.sock"
                "${CONFIGURED_ACTIONS_RUNNER_FILES_DIR}:${CONFIGURED_ACTIONS_RUNNER_FILES_DIR}"
                "${RUNNER_WORKDIR}:${RUNNER_WORKDIR}"
              ];
          };
        }
    )
  ) { } [
    "kamadorueda/alejandra"
  ];
}
