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
          # journalctl -fu docker-github-runner-*
          "github-runner-${name}" = rec {
            image = "myoung34/github-runner:latest";
            environment = {
              REPO_URL = "https://github.com/${repo}";
              RUNNER_NAME = name;
              RUNNER_WORKDIR = "/var/run/github-runner/${name}";
            };
            environmentFiles = [
              "${config.secrets.path}/machine/secrets.env"
            ];
            volumes =
              with environment;
              [
                "${RUNNER_WORKDIR}:${RUNNER_WORKDIR}"
                "/var/run/docker.sock:/var/run/docker.sock"
              ];
          };
        }
    )
  ) { } [
    "kamadorueda/alejandra"
  ];
}
