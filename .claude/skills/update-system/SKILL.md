---
name: update-system
description: Update flake.lock to latest versions of all dependencies
user-invocable: true
---

# Update System Dependencies

Update the flake.lock to the latest versions of all inputs (nixpkgs, fenix, home-manager, etc).

## Steps

1. **Update lockfile**
   ```
   nix flake update
   ```
   This fetches the latest versions from all input repositories and updates `flake.lock`.

2. **Build to test**
   ```
   nix build .#nixosConfigurations.machine.config.system.build.toplevel
   ```
   This validates the new dependencies work. The build will fail if there are compatibility issues to fix.

3. **Fix compatibility issues**

4. **Format and commit**
   ```
   scripts/format
   ```

## Notes

- Build times vary; allow 10-30 minutes for a full system build
- If the build fails, read the error carefully—it usually points to the problematic file and line
- Test thoroughly before applying to the running system
