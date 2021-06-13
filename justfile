build:
  nixos-rebuild build

diff:
  nixos-rebuild dry-activate

switch:
  sudo nixos-rebuild switch

test:
  sudo nixos-rebuild test

update:
  niv -s src/sources/sources.json
