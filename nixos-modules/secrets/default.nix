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

    sops.secrets."buildkite-public-age-key" = {
      restartUnits = ["container@buildkite-public.service"];
    };
    sops.secrets."buildkite-private-age-key" = {};
    sops.secrets."cloudflared-tunnel" = {};
    sops.secrets."gpg/kamadorueda@gmail.com/private" = {
      owner = config.wellKnown.username;
    };
    sops.secrets."wifi/24f42fdc30" = {
      mode = "400";
      path = "/etc/NetworkManager/system-connections/24f42fdc30";
      restartUnits = ["home-assistant.service"];
    };
    sops.secrets."wifi/spsetup-2c38" = {
      mode = "400";
      path = "/etc/NetworkManager/system-connections/spsetup-2c38";
      restartUnits = ["home-assistant.service"];
    };
    sops.secrets."ssh/kamadorueda/private" = {
      owner = config.wellKnown.username;
    };
    sops.secrets."user-password" = {
      neededForUsers = true;
    };
  };
}
