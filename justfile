build:
  nixos-rebuild build

diff:
  nixos-rebuild dry-activate

switch:
  sudo nixos-rebuild switch

update:
  niv -s src/sources/sources.json
