# Apply NixOS Configuration

Permanently apply NixOS configuration changes to the system.

## Prerequisites

1. Build the system using `/build-system`
2. Test changes with `/switch-to-configuration-test`
3. Verify changes work

## Run this command

```bash
sudo ./scripts/switch-to-configuration switch
```

## What it does

1. Sets the built configuration as the active system profile
2. Activates all system changes permanently
3. Updates GRUB bootloader
4. Reloads and restarts affected services

## Safety

- **Permanent change** to system
- Always test first with `/test-configuration`
- Can be reverted by building and applying a previous configuration
