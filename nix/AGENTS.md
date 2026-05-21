### Nix Workflow

The flake lives at `~/.dotfiles/nix`. Always work from that directory.

Available hosts (under `profiles/hosts/`):
```
ls profiles/hosts/
```
If the user does not specify a host, ask which one they want to change.

**Build check** (fast, no side effects):

```
nix build /home/yuxqiu/.dotfiles/nix#.homeConfigurations.<host>.activationPackage --no-link --print-out-paths 2>/dev/null
```

**Key conventions**:
- Module files go under `modules/` and are auto-discovered by `import-tree`.
- Each file declares `flake.modules.homeManager.<name>` (or `systemManager`, `generic`).
- Host config at `profiles/hosts/<host>.nix` lists which modules to include.
- `pkgs` is available inside the inner `flake.modules.*` function, not the outer one — the outer function receives `{ inputs, ... }`.
- `fetchFromGitHub` is preferred over flake inputs for non-Nix repos (no `flake.nix`). Pin the rev and add a `# follow:branch main` comment for easy updates via `nix-update-git`.
- After editing nix files, if there are newly added files, `git add` them before building — the flake evaluates the git-tracked tree.
- Do NOT apply changes (no `home-manager switch`, no `hm`). Build-check only; the user will apply themselves.
- When modifying configs that have runtime behavior (e.g. nvim, neovim, shell configs, services), try your best to test different workflows after building to ensure the modification is correct — not just that it builds.