# sops secrets/machine.yaml
# scripts/with-buildkite-age-key.sh public sops secrets/buildkite-public.yaml
# scripts/with-buildkite-age-key.sh private sops secrets/buildkite-private.yaml
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    secrets.ageKeyPath = lib.mkOption {type = lib.types.str;};
  };
  config = {
    environment.systemPackages = [pkgs.gnupg];
    environment.variables.SOPS_AGE_KEY_FILE = config.secrets.ageKeyPath;

    programs.ssh.startAgent = true;

    sops.age.keyFile = config.secrets.ageKeyPath;

    sops.defaultSopsFile = ../../secrets/machine.yaml;
  };
}
