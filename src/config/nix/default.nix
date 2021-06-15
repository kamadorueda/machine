_: with _; {
  gc = {
    automatic = true;
    dates = "00:00";
    persistent = true;
  };
  nixPath = [
    "nixos-config=${abs.home}/Documents/github/kamadorueda/machine/configuration.nix"
    "nixpkgs=${sources.nixpkgsNixos}"
  ];
  optimise = {
    automatic = true;
    dates = [ "00:00" ];
  };
  readOnlyStore = true;
  trustedUsers = [
    "root"
    abs.username
  ];
  useSandbox = true;
}
