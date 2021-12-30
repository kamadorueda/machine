set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

gc:
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
  nix-collect-garbage -d
  nix-store --optimise

rebuild *ARGS:
  nixos-generate-config --show-hardware-config \
    > nixos-modules/hardware/auto-detected.nix
  git diff -- nixos-modules/hardware/auto-detected.nix
  sudo nixos-rebuild --flake .#machine --show-trace -L -v {{ARGS}}
