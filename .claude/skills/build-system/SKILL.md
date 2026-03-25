# Build NixOS System

Build the NixOS system configuration.

## Run this command

```bash
nix \
  --extra-experimental-features flakes \
  --extra-experimental-features nix-command \
  --extra-experimental-features pipe-operators \
  --verbose \
  build \
  --print-build-logs \
  .#nixosConfigurations.machine.config.system.build.toplevel
```

Or use the script:

```bash
./scripts/build-system
```

## What it does

1. Evaluates the NixOS configuration
2. Compiles all system packages and configurations
3. Creates a `result` symlink to the built system profile

## Next steps

- After building, use `/switch-to-configuration-test` to test changes (temporary)
- Or use `/switch-to-configuration` to apply permanently
