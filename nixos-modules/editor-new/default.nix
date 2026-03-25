{pkgs, ...}: {
  environment.systemPackages = [pkgs.superset pkgs.zed-editor];
}
