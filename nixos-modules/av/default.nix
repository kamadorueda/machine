{nixpkgs, ...}: {
  environment.systemPackages = [nixpkgs.clamav];

  # ClamAV clamd daemon.
  services.clamav.daemon.enable = true;

  # ClamAV freshclam updater.
  services.clamav.updater.enable = true;
  # How often freshclam is invoked.
  services.clamav.updater.interval = "hourly";
  # Number of database checks per day.
  services.clamav.updater.frequency = 12;
}
