set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

gc:
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  nix-collect-garbage -d
  nix-store --optimise

niv *ARGS:
  niv -s src/sources/sources.json {{ARGS}}

rebuild *ARGS:
  nixos-generate-config --show-hardware-config > components/hardware/auto.nix
  git diff -- components/hardware/auto.nix
  @echo
  @read -N 1 -p 'Pess a key to continue...' -r
  sudo nixos-rebuild --flake .#machine --show-trace {{ARGS}}
