_: with _; {
  enableDefaultFonts = true;
  fonts = [
    inputs.nixpkgs.powerline-fonts
  ];
  fontconfig = {
    enable = true;
  };
}
