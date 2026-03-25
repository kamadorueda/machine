---
name: buildkite-runner
description: Start and manage the buildkite public runner using nixos-container
user-invocable: true
---

# Buildkite Public Runner

## Quick Start

```bash
nixos-container start buildkite-public
nixos-container status buildkite-public
```

## Common Commands

```bash
# List all containers
nixos-container list

# Start container
nixos-container start buildkite-public

# Stop container
nixos-container stop buildkite-public

# Restart container
nixos-container restart buildkite-public

# Check status
nixos-container status buildkite-public

# Login to container
nixos-container login buildkite-public

# Run command in container
nixos-container run buildkite-public -- systemctl status buildkite-agent-default.service

# View logs
nixos-container run buildkite-public -- journalctl -u buildkite-agent-default.service -f

# Get IP address
nixos-container show-ip buildkite-public
```

## Configuration

- Defined in: `nixos-modules/buildkite/default.nix`
- Uses ephemeral storage (changes don't persist after reboot)
- Limited to 1 core, 1 job to minimize resource usage
- Secrets managed via SOPS age encryption

## Setup Secrets

```bash
./scripts/with-buildkite-age-key public nixos-container start buildkite-public
```

## Related

- `/nixos-workflow` - Build and test NixOS config
- `./scripts/build-system` - Rebuild system
