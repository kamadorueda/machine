_: with _; {
  buildCores = 0;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  maxJobs = 1;
  nixPath = [
    "nixos-config=${abs.machine}/configuration.nix"
    "nixpkgs=${sources.nixpkgs}"
  ];
  optimise = {
    automatic = true;
    dates = [ "12:00" ];
  };
  package = packages.nixpkgs.nixUnstable;
  readOnlyStore = true;
  trustedUsers = [
    "root"
    abs.username
  ];
  useSandbox = true;
}
