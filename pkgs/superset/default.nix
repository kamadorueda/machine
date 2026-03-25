{pkgs}:
let
  version = "1.3.2";
  desktopVersion = "desktop-v${version}";
  appimageFile = "superset-${version}-x86_64.AppImage";
in
pkgs.appimageTools.wrapType2 {
  pname = "superset";
  version = version;
  src = pkgs.fetchurl {
    url = "https://github.com/superset-sh/superset/releases/download/${desktopVersion}/${appimageFile}";
    sha256 = "sha256-8UlnuXEU8mZVN6SLMfjC1fvuBrTe841pbhOUh0w//w8=";
  };
  extraPkgs = pkgs: [];
}
