_: with _; {
  enableDefaultFonts = true;
  fonts = [
    packages.nixpkgs.powerline-fonts
  ];
  fontconfig = {
    enable = true;
  };
}
