# Comprehensive Refactoring Plan

A NixOS machine-as-code configuration (~2700 lines) for a Framework laptop. 18 NixOS modules in `nixos-modules/`, 2 custom packages in `pkgs/`, 11 scripts in `scripts/`.

---

## Tier 1: Bugs and Correctness Issues

These are safe, isolated fixes. Do them one at a time. Build after each to verify.

---

### 1.1 Fix typo: `gpg.progam` -> `gpg.program`

**File:** `/data/machine/nixos-modules/terminal/default.nix`
**Line:** 103

**Current code:**
```nix
    gpg.progam = getExe' pkgs.gnupg "gpg2";
```

**Replace with:**
```nix
    gpg.program = getExe' pkgs.gnupg "gpg2";
```

**Why:** `progam` is a typo. Git ignores the misspelled key, so it never finds the GPG binary via this config.

**Verify:** Run `/build-system`. It should succeed.

---

### 1.2 Delete dead `mkcert` module

**File to delete:** `/data/machine/nixos-modules/mkcert/default.nix`

**Why:** This file is never imported in `flake.nix`, so it has no effect. It also has a bug: it uses `config.wellKnown.username` but its function arguments are `{pkgs, ...}:` (missing `config`). It would crash if imported.

**Steps:**
1. Delete the file: `rm /data/machine/nixos-modules/mkcert/default.nix`
2. Delete the empty directory: `rmdir /data/machine/nixos-modules/mkcert`
3. Run `/build-system` to confirm nothing breaks.

---

### 1.3 Add explicit `system.stateVersion`

**File to edit:** `/data/machine/nixos-modules/users/default.nix`

**Why:** `home.stateVersion = config.system.stateVersion;` on line 5 reads `system.stateVersion`, but it's never explicitly set. NixOS has a default, but it changes between releases and should be pinned.

**Current code (lines 1-7):**
```nix
{config, ...}: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${config.wellKnown.username} = {
    home.stateVersion = config.system.stateVersion;
  };
```

**Replace with:**
```nix
{config, ...}: {
  system.stateVersion = "24.11";

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.${config.wellKnown.username} = {
    home.stateVersion = config.system.stateVersion;
  };
```

**Important:** Ask the user which NixOS version they originally installed with. Use that version string. `"24.11"` is a placeholder.

**Verify:** Run `/build-system`.

---

## Tier 2: Architectural Improvements

These are structural changes. Each one touches multiple files. Do them one at a time, building after each.

---

### 2.1 Replace `_meta` module with `specialArgs`

The `_meta` module's only job is to pass flake inputs to other modules. NixOS has a built-in mechanism for this: `specialArgs`.

**Step 1: Edit `flake.nix`**

In the `machine` nixosSystem call (around line 90), add `specialArgs`:

**Current:**
```nix
      machine = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = builtins.attrValues inputs.self.nixosModules;
      };
```

**Replace with:**
```nix
      machine = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {flakeInputs = inputs;};
        modules = builtins.attrValues inputs.self.nixosModules;
      };
```

Do the same for the `installer` nixosSystem call (around line 94):

**Current:**
```nix
      installer = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
```

**Replace with:**
```nix
      installer = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {flakeInputs = inputs;};
        modules = [
```

**Step 2: Remove `_meta` from `flake.nix`**

Delete these two lines from `nixosModules` (around lines 28-29):
```nix
      _meta = import ./nixos-modules/_meta {inherit inputs;};
```

Also remove `inputs.self.nixosModules._meta` from the installer modules list (around line 98).

**Step 3: Delete the `_meta` module**

```bash
rm /data/machine/nixos-modules/_meta/default.nix
rmdir /data/machine/nixos-modules/_meta
```

**Verify:** Run `/build-system`. All modules that use `flakeInputs` (`nix`, `nixpkgs`, `terminal`) should still work because `specialArgs` makes `flakeInputs` available as a module argument.

---

### 2.2 Use `pkgs.claude-code` from overlay instead of direct flake reference

**File:** `/data/machine/nixos-modules/terminal/default.nix`
**Line:** 49

**Current:**
```nix
    flakeInputs.self.packages."x86_64-linux".claude-code
```

**Replace with:**
```nix
    pkgs.claude-code
```

**Why:** The overlay in `nixpkgs/default.nix` already applies `flakeInputs.self.overlays.default`, which provides `pkgs.claude-code`. Using the overlay is more idiomatic and avoids hardcoding the system architecture.

**Verify:** Run `/build-system`.

---

### 2.3 Simplify the `alias'` function

**File:** `/data/machine/nixos-modules/nixpkgs/default.nix`
**Lines:** 13-29 (the inner overlay)

**Current code:**
```nix
    (final: prev: let
      inherit (final.lib.meta) getExe getExe';
      inherit (final.lib.strings) escapeShellArgs;
    in {
      alias = to: pkg: final.alias' to pkg pkg.meta.mainProgram;

      alias' = to: pkg: from: extraArgs:
        final.writeShellApplication {
          name = to;
          runtimeEnv = {
            EXTRA_ARGS = extraArgs;
          };
          text = ''
            exec ${getExe' pkg from} "''${EXTRA_ARGS[@]}" "$@"
          '';
        };
    })
```

**Replace with:**
```nix
    (final: prev: let
      inherit (final.lib.meta) getExe getExe';
      inherit (final.lib.strings) escapeShellArgs;
    in {
      alias = to: pkg: final.alias' to pkg pkg.meta.mainProgram;

      alias' = to: pkg: from: extraArgs:
        final.writeShellApplication {
          name = to;
          text = ''exec ${getExe' pkg from} ${escapeShellArgs extraArgs} "$@"'';
        };
    })
```

**Why:** The old version passed a list through `runtimeEnv` and relied on bash array expansion (`"${EXTRA_ARGS[@]}"`). The new version uses `escapeShellArgs` to inline the args at build time, which is simpler and explicit. Note that `escapeShellArgs` is already imported in the `let` block but was unused.

**Verify:** Run `/build-system`.

---

### 2.4 Move `wellKnown.editor` option to `well-known` module

The `editor` module currently defines an option in the `wellKnown` namespace. The `wellKnown.*` options should all be defined in the `well-known` module.

**Step 1: Edit `/data/machine/nixos-modules/well-known/default.nix`**

**Current:**
```nix
{lib, ...}: {
  options = {
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
}
```

**Replace with:**
```nix
{lib, ...}: {
  options = {
    wellKnown.editor = lib.mkOption {
      type = lib.types.package;
      description = "The editor package with config directory preconfigured";
    };
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
}
```

**Step 2: Edit `/data/machine/nixos-modules/editor/default.nix`**

Remove the `options` block entirely (lines 26-30):
```nix
  options = {
    wellKnown.editor = lib.mkOption {
      type = lib.types.package;
      description = "The zed editor package with config directory preconfigured";
    };
  };
```

Also remove `lib` from the function arguments since it's no longer needed:

**Current (line 1-5):**
```nix
{
  config,
  lib,
  pkgs,
  ...
```

**Replace with:**
```nix
{
  config,
  pkgs,
  ...
```

**Verify:** Run `/build-system`.

---

### 2.5 Merge `*Config` entries into their respective modules

The `flake.nix` has four `*Config` entries that are just inline config values. These should move into the modules they configure.

**Step 1: Move `wellKnownConfig` into `well-known/default.nix`**

Add a `config` block to `/data/machine/nixos-modules/well-known/default.nix`:

**Current:**
```nix
{lib, ...}: {
  options = {
    wellKnown.editor = lib.mkOption { ... };
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
}
```

**Replace with:**
```nix
{lib, ...}: {
  options = {
    wellKnown.editor = lib.mkOption {
      type = lib.types.package;
      description = "The editor package with config directory preconfigured";
    };
    wellKnown.email = lib.mkOption {type = lib.types.str;};
    wellKnown.name = lib.mkOption {type = lib.types.str;};
    wellKnown.username = lib.mkOption {type = lib.types.str;};
  };
  config = {
    wellKnown.email = "kamadorueda@gmail.com";
    wellKnown.name = "Kevin Amado";
    wellKnown.username = "kamadorueda";
  };
}
```

Then delete from `flake.nix`:
```nix
      wellKnownConfig = {
        wellKnown.email = "kamadorueda@gmail.com";
        wellKnown.name = "Kevin Amado";
        wellKnown.username = "kamadorueda";
      };
```

**Step 2: Move `uiConfig` into `ui/default.nix`**

In `/data/machine/nixos-modules/ui/default.nix`, add default values to the options:

Change line 8-9 from:
```nix
    ui.fontSize = lib.mkOption {type = lib.types.ints.positive;};
    ui.timezone = lib.mkOption {type = lib.types.str;};
```
to:
```nix
    ui.fontSize = lib.mkOption {type = lib.types.ints.positive; default = 16;};
    ui.timezone = lib.mkOption {type = lib.types.str; default = "America/Edmonton";};
```

Then delete from `flake.nix`:
```nix
      uiConfig = {
        ui.fontSize = 16;
        ui.timezone = "America/Edmonton";
      };
```

**Step 3: Move `secretsConfig` into `secrets/default.nix`**

In `/data/machine/nixos-modules/secrets/default.nix`, add a default to the option:

Change line 11 from:
```nix
    secrets.ageKeyPath = lib.mkOption {type = lib.types.str;};
```
to:
```nix
    secrets.ageKeyPath = lib.mkOption {type = lib.types.str; default = "/data/age-key.txt";};
```

Then delete from `flake.nix`:
```nix
      secretsConfig = {config, ...}: {
        secrets.ageKeyPath = "/data/age-key.txt";
      };
```

**Step 4: Move `fhsConfig` into `fhs/default.nix`**

In `/data/machine/nixos-modules/fhs/default.nix`, add a default to the packages option:

Change line 9 from:
```nix
    fhs.packages = lib.mkOption {
      type = lib.types.listOf lib.types.path;
    };
```
to:
```nix
    fhs.packages = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
    };
```

Then create a new file `/data/machine/nixos-modules/fhs/config.nix` or just add the config inline. Actually, the simpler approach: add the fhs packages directly in `fhs/default.nix`:

Add to the `config` block:
```nix
  config = {
    fhs.packages = [
      pkgs.glibc.out
      pkgs.glibc.dev
      pkgs.openssl.out
      pkgs.openssl.dev
    ];
    fileSystems = ...  # existing code
  };
```

Wait - you need `pkgs` in the arguments. Currently the file has `{config, lib, pkgs, ...}:` so `pkgs` is available. Add the packages to the config block.

Then delete from `flake.nix`:
```nix
      fhsConfig = {pkgs, ...}: {
        fhs.packages = [
          pkgs.glibc.out
          pkgs.glibc.dev
          pkgs.openssl.out
          pkgs.openssl.dev
        ];
      };
```

**Step 5: Clean up `flake.nix`**

After steps 1-4, remove the `installer`'s reference to `inputs.self.nixosModules.wellKnownConfig` (line 103). The well-known values are now in the module itself, so the installer gets them automatically when it imports `inputs.self.nixosModules.wellKnown`.

**Verify:** Run `/build-system` after each step.

---

### 2.6 Extract shared settings-deployer pattern

Both `claude-code/default.nix` and `editor/default.nix` have nearly identical systemd service patterns. Create a shared helper.

**Step 1: Create `/data/machine/nixos-modules/lib.nix`**

```nix
# Shared helper functions for NixOS modules in this repository.
{pkgs}: {
  # Creates a systemd oneshot service that deploys a JSON settings file
  # to a config directory.
  #
  # Arguments:
  #   name: service name suffix (e.g., "editor-setup")
  #   configDir: absolute path to deploy settings to (e.g., "/data/editor/config")
  #   settings: Nix attrset to serialize as settings.json
  #   extraServiceConfig: optional extra systemd service config attrs (default {})
  #
  # Returns: a systemd.services attrset with one service.
  mkSettingsService = {
    name,
    configDir,
    settings,
    extraServiceConfig ? {},
    rmFirst ? false,
  }: let
    inherit (pkgs.lib.lists) concatLists;
    settingsJson = (pkgs.formats.json {}).generate "settings.json" settings;
  in {
    systemd.services."machine-${name}" = {
      script = toString (pkgs.substitute {
        src = pkgs.writeShellScript "machine-${name}.sh" (
          ''
            set -eux

          ''
          + (
            if rmFirst
            then ''
              rm -rf "@configDir@"
            ''
            else ""
          )
          + ''
            mkdir -p "@configDir@"

            cp --dereference --no-preserve=mode,ownership \
              "@settings@" "@configDir@/settings.json"
          ''
        );
        substitutions = concatLists [
          ["--replace-fail" "@configDir@" configDir]
          ["--replace-fail" "@settings@" settingsJson]
        ];
        isExecutable = true;
      });
      serviceConfig =
        {
          RemainAfterExit = true;
          Type = "oneshot";
        }
        // extraServiceConfig;
      unitConfig = {
        After = ["multi-user.target"];
      };
      requiredBy = ["multi-user.target"];
    };
  };
}
```

**Step 2: Rewrite `/data/machine/nixos-modules/claude-code/default.nix`**

```nix
{
  config,
  pkgs,
  ...
}: let
  lib' = import ../lib.nix {inherit pkgs;};
  settings = import ./settings.nix {inherit config pkgs;};
in {
  config =
    {
      environment.systemPackages = [pkgs.claude-code];
    }
    // lib'.mkSettingsService {
      name = "claude-code-setup";
      configDir = "/data/.claude";
      inherit settings;
    };
}
```

**Step 3: Rewrite `/data/machine/nixos-modules/editor/default.nix`**

```nix
{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.meta) getExe;

  lib' = import ../lib.nix {inherit pkgs;};

  configDir = "/data/editor/config";

  basePackage = pkgs.zed-editor;

  zed = pkgs.writeShellApplication {
    name = "zed";
    runtimeEnv = {
      ZED_CONFIG_DIR = configDir;
    };
    text = ''exec ${getExe basePackage} "$@"'';
  };

  settings = import ./settings.nix {inherit config pkgs;};
in {
  config =
    {
      wellKnown.editor = zed;

      environment.variables.EDITOR = "editor";
      environment.systemPackages = [pkgs.superset zed];

      home-manager.users.${config.wellKnown.username} = {
        home.file.".config/rustfmt/rustfmt.toml".source = ./rustfmt.toml;
      };

      programs.git.config = {
        diff.tool = "editor";
        difftool.editor.cmd = "editor --wait --diff $LOCAL $REMOTE";
        merge.tool = "editor";
        mergetool.editor.cmd = "editor --wait $MERGED";
      };
    }
    // lib'.mkSettingsService {
      name = "editor-setup";
      inherit configDir settings;
      rmFirst = true;
      extraServiceConfig = {
        Group = config.users.users.${config.wellKnown.username}.group;
        User = config.wellKnown.username;
      };
      requiredBy = ["graphical.target"];
    };
}
```

Wait - actually, the `requiredBy` is different (graphical.target vs multi-user.target). Let me adjust the helper. Actually, looking at this more carefully, the pattern merge with `//` won't deeply merge `systemd.services` if the module has other systemd config. Let me reconsider.

Actually, the better approach for NixOS modules is to use `lib.mkMerge` or just put it all in the config attrset. Let me simplify: instead of returning a config attrset, the helper should return just the service definition, and the caller puts it in the right place.

Let me redo this. Actually, this task is getting complex enough that the implementation details may need adjustment. Let me keep the plan high-level here and mark it as "needs careful implementation."

**Note for implementer:** The `//` merge approach won't deep-merge nested attrsets. Use `lib.mkMerge` or have the helper return only the service attrs (not wrapped in `systemd.services`). Test carefully.

**Verify:** Run `/build-system`.

---

## Tier 3: Reliability and Maintainability

---

### 3.1 Add `checks` to the flake

**File:** `/data/machine/flake.nix`

Add a new top-level output after `packages`:

```nix
    checks."x86_64-linux" = let
      pkgs = (inputs.nixpkgs.legacyPackages."x86_64-linux").extend inputs.self.overlays.default;
    in {
      build = inputs.self.nixosConfigurations.machine.config.system.build.toplevel;
      formatting = pkgs.runCommand "check-formatting" {
        nativeBuildInputs = [pkgs.alejandra];
      } ''
        alejandra --check ${inputs.self} && touch $out
      '';
    };
```

**Why:** The `buildkite.yaml` runs `nix flake check`, but no checks are defined. This adds a system build check and a formatting check.

**Verify:** Run `nix flake check`.

---

### 3.2 Deduplicate nix boilerplate in scripts

**Files:** `scripts/build-installer` and `scripts/build-system`

Both repeat these 4 lines:
```bash
nix \
  --extra-experimental-features flakes \
  --extra-experimental-features nix-command \
  --extra-experimental-features pipe-operators \
  --verbose \
```

**Step 1: Create `/data/machine/scripts/_nix-build`**

```bash
#!/usr/bin/env bash

set -euo pipefail

exec nix \
  --extra-experimental-features flakes \
  --extra-experimental-features nix-command \
  --extra-experimental-features pipe-operators \
  --verbose \
  build \
  --print-build-logs \
  "$@"
```

Make it executable: `chmod +x scripts/_nix-build`

**Step 2: Simplify `scripts/build-installer`**

```bash
#!/usr/bin/env bash

set -euo pipefail

scripts/_nix-build .#installer
```

**Step 3: Simplify `scripts/build-system`**

```bash
#!/usr/bin/env bash

set -euo pipefail

scripts/_nix-build \
  .#nixosConfigurations.machine.config.system.build.toplevel \
  "${@}"
```

**Verify:** Run both scripts and confirm they produce the same output as before.

---

### 3.3 Move GPG/SSH import out of `interactiveShellInit`

**File:** `/data/machine/nixos-modules/terminal/default.nix`
**Lines:** 88-97

**Current:**
```nix
  programs.bash.interactiveShellInit = ''
    export AWS_CONFIG_FILE=/data/aws-config
    export AWS_SHARED_CREDENTIALS_FILE=/data/aws-credentials
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)

    export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent
    gpg --import < ${config.sops.secrets."gpg/kamadorueda@gmail.com/private".path}
    ssh-add ${config.sops.secrets."ssh/kamadorueda/private".path}
  '';
```

**Replace with:**
```nix
  programs.bash.interactiveShellInit = ''
    export AWS_CONFIG_FILE=/data/aws-config
    export AWS_SHARED_CREDENTIALS_FILE=/data/aws-credentials
    export DIRENV_WARN_TIMEOUT=1h
    source <(direnv hook bash)

    export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent
  '';
  programs.bash.loginShellInit = ''
    gpg --import < ${config.sops.secrets."gpg/kamadorueda@gmail.com/private".path}
    ssh-add ${config.sops.secrets."ssh/kamadorueda/private".path}
  '';
```

**Why:** `interactiveShellInit` runs on every new terminal window. `loginShellInit` runs once per login session. GPG import and SSH key add only need to happen once.

**Verify:** Run `/build-system`, then open multiple terminal windows and confirm GPG/SSH only runs on the first login shell.

---

## Tier 4: Elegance and Code Quality

---

### 4.1 Consolidate hardcoded `/data/*` paths

**Step 1: Add `wellKnown.dataDir` option to `/data/machine/nixos-modules/well-known/default.nix`**

Add to options:
```nix
    wellKnown.dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data";
      description = "Base directory for persistent data";
    };
```

**Step 2: Update modules to use it**

In each module, replace hardcoded `/data/...` paths with `"${config.wellKnown.dataDir}/..."`. For example:

- `browser/default.nix`: `"/data/browser/data"` -> `"${config.wellKnown.dataDir}/browser/data"`
- `claude-code/default.nix`: `"/data/.claude"` -> `"${config.wellKnown.dataDir}/.claude"`
- `terminal/default.nix`: `"/data/aws-config"` -> `"${config.wellKnown.dataDir}/aws-config"`
- `ui/default.nix`: `"/data/xdg/desktop"` -> `"${config.wellKnown.dataDir}/xdg/desktop"` (and all other xdg paths)

**Why:** Documents the convention and makes the data mount point configurable from one place.

**Verify:** Run `/build-system`.

---

### 4.2 Replace no-op `shell` package with `devShells`

**Step 1: Edit `flake.nix`**

Remove from `packages`:
```nix
      shell = pkgs.writeShellApplication {
        name = "shell";
        runtimeInputs = [pkgs.coreutils];
        text = "";
      };
```

Add a new output:
```nix
    devShells."x86_64-linux".default = let
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    in pkgs.mkShell {
      packages = [pkgs.coreutils];
    };
```

**Step 2: Simplify `.envrc`**

**Current:**
```bash
strict_env

layout_dir="$(direnv_layout_dir)"

PATH_add scripts
nix build .#shell --out-link "${layout_dir}/shell"
source "${layout_dir}/shell/bin/shell"

echo
tree --noreport scripts
echo
```

**Replace with:**
```bash
strict_env

PATH_add scripts
use flake

echo
tree --noreport scripts
echo
```

**Why:** `devShells` + `use flake` is the standard Nix + direnv pattern. The `shell` package was an empty wrapper just to get `coreutils` on PATH.

**Verify:** Run `direnv allow` in the repo root and confirm the environment loads.

---

### 4.3 Split `terminal/default.nix` into terminal + git modules

This is the largest module (117 lines) handling many unrelated concerns.

**Step 1: Create `/data/machine/nixos-modules/git/default.nix`**

Move git-related config out of terminal. New file:

```nix
{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib.meta) getExe getExe';
in {
  programs.git.config = {
    commit.gpgsign = true;
    diff.renamelimit = 16384;
    diff.sopsdiffer.textconv =
      getExe (pkgs.alias "sopsdiffer" pkgs.sops ["decrypt"]);
    gpg.program = getExe' pkgs.gnupg "gpg2";
    gpg.sign = true;
    init.defaultbranch = "main";
    user.email = config.wellKnown.email;
    user.name = config.wellKnown.name;
  };
  programs.git.enable = true;

  sops.secrets."gpg/kamadorueda@gmail.com/private" = {
    owner = config.wellKnown.username;
  };
  sops.secrets."ssh/kamadorueda/private" = {
    owner = config.wellKnown.username;
  };
}
```

**Step 2: Remove those lines from `terminal/default.nix`**

Remove lines 98-116 (everything from `programs.git.config` through the `sops.secrets` entries).

**Step 3: Add `git` module to `flake.nix`**

In `nixosModules`, add:
```nix
      git = import ./nixos-modules/git;
```

**Step 4: Move GPG/SSH init to git module**

The `programs.bash.loginShellInit` with GPG/SSH commands (from task 3.3) should also move to the git module since it's about GPG/SSH keys used for git signing.

**Verify:** Run `/build-system`.

---

## Tier 5: Testability

---

### 5.1 Add NixOS VM test

**File:** `/data/machine/flake.nix`

Add to the `checks` output (from task 3.1):

```nix
      vm-test = pkgs.nixosTest {
        name = "machine-boots";
        nodes.machine = {
          imports = builtins.attrValues inputs.self.nixosModules;
        };
        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed("which claude")
        '';
      };
```

**Note:** This may need adjustments because some modules (like `physical`) have hardware-specific config that won't work in a VM. You may need to exclude those modules or provide VM-compatible overrides.

**Verify:** Run `nix flake check` or `nix build .#checks.x86_64-linux.vm-test`.

---

## Implementation Order

Execute tasks in this order. Build after each. Stop and investigate if a build fails.

| Order | Task | Risk | Effort |
|-------|------|------|--------|
| 1 | 1.1 Fix `gpg.progam` typo | None | 1 line |
| 2 | 1.2 Delete dead mkcert module | None | Delete 1 file |
| 3 | 1.3 Add `system.stateVersion` | None | 1 line (ask user for version) |
| 4 | 2.2 Use `pkgs.claude-code` from overlay | None | 1 line |
| 5 | 2.3 Simplify `alias'` function | Low | 5 lines |
| 6 | 2.1 Replace `_meta` with `specialArgs` | Low | 3 files |
| 7 | 2.4 Move `wellKnown.editor` option | Low | 2 files |
| 8 | 2.5 Merge `*Config` into modules | Low | 5 files |
| 9 | 3.3 Move GPG/SSH to `loginShellInit` | Low | 1 file |
| 10 | 3.2 Deduplicate script boilerplate | Low | 3 files |
| 11 | 4.3 Split terminal into terminal + git | Medium | 3 files |
| 12 | 2.6 Extract settings-deployer pattern | Medium | 3 files |
| 13 | 3.1 Add flake checks | Medium | 1 file |
| 14 | 4.1 Consolidate `/data/*` paths | Medium | 6+ files |
| 15 | 4.2 Replace shell with devShells | Low | 2 files |
| 16 | 5.1 Add VM test | High | 1 file |
