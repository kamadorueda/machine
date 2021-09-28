_: with _; {
  buildCores = 0;
  gc = {
    automatic = true;
    dates = "12:00";
    persistent = true;
  };
  maxJobs = 1;
  nixPath = [
    "nixos-config=${abs.machine}/configuration.nix"
    "nixpkgs=${sources.nixpkgsNixos}"
  ];
  optimise = {
    automatic = true;
    dates = [ "12:00" ];
  };
  readOnlyStore = true;
  trustedUsers = [
    "root"
    abs.username
  ];
  useSandbox = true;
}
