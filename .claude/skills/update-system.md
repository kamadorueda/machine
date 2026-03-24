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
   Common issues when updating:
   - **Renamed packages**: Check error messages for package renames (e.g., `noto-fonts-emoji` → `noto-fonts-color-emoji`) and update `nixos-modules/`
   - **Configuration conflicts**: Resolve conflicting options (e.g., duplicate SSH agents) by adjusting settings in relevant modules

4. **Format and commit**
   ```
   scripts/format
   git add flake.lock flake.nix nixos-modules/ pkgs/
   git commit -m "chore: update dependencies"
   ```

## Notes

- Build times vary; allow 10-30 minutes for a full system build
- If the build fails, read the error carefully—it usually points to the problematic file and line
- Test thoroughly before applying to the running system
