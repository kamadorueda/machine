_: with _;

(import ./local.nix) // {
  swapDevices = [
    {
      device = "/swap";
      size = 8000; # MB
    }
  ];
}
