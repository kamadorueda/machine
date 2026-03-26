---
name: update-packages
description: Update Claude Code and other npm packages in pkgs/
user-invocable: true
---

# Update Packages

Update npm packages in the `/data/machine/pkgs/` directory, including Claude Code.

## Steps

1. **Update Claude Code dependencies**
   ```
   cd /data/machine/pkgs/claude-code && npm update
   ```
   This updates the `@anthropic-ai/claude-code` dependency to the latest version and resolves transitive dependencies.

2. **Build the package to test**
   ```
   cd /data/machine && nix build .#packages.x86_64-linux.claude-code
   ```
   This validates that the updated dependencies work correctly with the Nix build system.

3. **Verify the build**
   ```
   ./result/bin/claude --version
   ```
   Confirm the updated Claude Code is working properly.

4. **Update package-lock.json**
   After npm update, the `package-lock.json` should be updated. If changes are made to `pkgs/claude-code/package-lock.json`, commit them.

## Notes

- The build downloads dependencies from npm registry and nix-community cache
- Build times vary; allow 5-10 minutes for a full build
- If the build fails, check compatibility between updated packages
- After updating, apply the new configuration with `switch-to-configuration`
