# Test NixOS Configuration

Test NixOS configuration changes safely. Changes are temporary and auto-revert after timeout if not confirmed.

## Prerequisites

Build the system first using `/build-system`

## Run this command

```bash
sudo ./scripts/switch-to-configuration test
```

## What it does

1. Applies the built configuration in test mode (temporary)
2. Auto-reverts after timeout unless confirmed

## Safety

- Changes are **temporary** and auto-revert
- Safe to test breaking changes
- No permanent system modification
