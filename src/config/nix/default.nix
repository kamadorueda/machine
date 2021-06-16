_: with _; {
  gc = {
    automatic = true;
    dates = "12:00";
    persistent = true;
  };
  nixPath = [
    "nixos-config=${abs.machine}/configuration.nix"
    "nixpkgs=${sources.nixpkgsNixos}"
  ];
  optimise = {
    automatic = true;
    dates = [ "12:00" ];
  };
  readOnlyStore = false;
  trustedUsers = [
    "root"
    abs.username
  ];
  useSandbox = true;
}
