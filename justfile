set shell := ["bash", "-euo", "pipefail", "-c"]

_:
  @just --list

gc:
  just gc-nixos
  just gc-nix

gc-nix:
  nix-collect-garbage -d
  nix-store --optimise

gc-nixos:
  sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

update-hardware:
  nixos-generate-config --show-hardware-config \
    > nixos-modules/hardware/auto-detected.nix
  git diff -- nixos-modules/hardware/auto-detected.nix

rebuild *ARGS:
  sudo nixos-rebuild \
    --flake .#machine \
    --show-trace \
    -L \
    -v \
    --option substituters '' \
    --impure \
    {{ARGS}}
