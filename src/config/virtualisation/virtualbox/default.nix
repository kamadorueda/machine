_: with _; {
  guest = {
    x11 = true;
    enable = true;
  };
  host = {
    enable = true;
    headless = false;
    enableHardening = true;
    addNetworkInterface = true;
    enableExtensionPack = false;
  };
}
