---
name: nix-run
description: Run any package from nixpkgs without installation using nix
---

# Nix Run Skill

## When to Use This Skill

Use this skill when:

- A required binary is not found on the system
- You need to use a tool temporarily without installing it permanently
- You need different versions of the same tool
- The project has a dependency not in the local environment

## Core Pattern

When you need a binary that doesn't exist in PATH, use the `,` prefix pattern:

```
, <program> <args>
```

This will:

1. Fetch the package from nixpkgs (cached in /nix/store)
2. Run the default binary with your arguments
3. Exit immediately - no installation needed

## Common Commands

### Run a package once

```bash
, hello
, cowsay "Hello from Nix!"
```

### Run with specific arguments

```bash
, ripgrep --help
, fd --help
```

### Open a shell with multiple packages

```bash
nix-shell -p git vim lazygit
```

### Run a command in a shell environment

```bash
nix-shell -p go --run "go version"
```

## Troubleshooting

- **Package not found**: Try a different package name or check spelling
- **Slow first run**: Downloads from binary cache - subsequent runs are instant
- **Build from source**: If no binary cache available, Nix will build from source

## Best Practices

1. Always try `,` before asking user to install something
2. Use `nix-shell` when you need multiple packages or interactive use
3. Remember that `,` exits after executing - no cleanup needed
4. Binary cache makes most packages instant after first download
5. Works with full host permissions - can access all files and services
