{config, ...}: {
  environment.variables.SOPS_AGE_KEY_FILE = config.secrets.ageKeyPath;

  sops.age.keyFile = config.secrets.ageKeyPath;

  sops.defaultSopsFile = ./secrets.yaml;

  sops.secrets.buildkite-token = {};
  sops.secrets.cachix-auth-token-alejandra = {};
  sops.secrets.coveralls-kamadorueda-alejandra = {};
  sops.secrets.coveralls-kamadorueda-nixel = {};
  sops.secrets.coveralls-kamadorueda-santiago = {};
  sops.secrets.coveralls-kamadorueda-toros = {};
  sops.secrets.cloudflared-tunnel = {};

  sops.secrets."gpg/kamadorueda@gmail.com/private" = {};

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

  sops.secrets."ssh/kamadorueda/private" = {};

  sops.secrets.user-password.neededForUsers = true;
}
