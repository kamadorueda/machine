_: with _; {
  guest = {
    x11 = true;
    enable = true;
  };
  host = {
    enable = true;
    headless = false;
    enableHardening = false;
    addNetworkInterface = true;
    enableExtensionPack = true;
  };
}
