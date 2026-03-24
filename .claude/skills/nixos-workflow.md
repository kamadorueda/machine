# NixOS Configuration Workflow

When modifying nixos-modules, follow this workflow to build and test changes.

## Step 1: Build the system

```
scripts/build-system
```

This compiles the new NixOS configuration and creates a `result` symlink. It does NOT apply changes to the running system. Run this after:
- Adding a new module to `nixos-modules/`
- Registering it in `flake.nix` under `nixosModules`
- Modifying existing module configurations

## Step 2: Test the configuration

```
sudo scripts/switch-to-configuration test
```

This applies the built configuration in test mode. Changes will automatically revert after a timeout if you don't confirm, allowing you to verify everything works without risk. If something breaks, the system rolls back.

## Optional: Permanent switch

After confirming the test works:

```
sudo scripts/switch-to-configuration switch
```

This permanently applies the configuration to the system.

## Full Example

1. Create/modify module in `nixos-modules/`
2. Register in `flake.nix`
3. `scripts/build-system`
4. `sudo scripts/switch-to-configuration test`
5. Verify changes work
6. `sudo scripts/switch-to-configuration switch` (if satisfied)
