## VSCode Settings

This directory stores all the vscode settings (settings, keybindings, and extensions).

### Getting Started

First, install [Sync Settings](https://github.com/zokugun/vscode-sync-settings) extension.

### Sync Settings Setting

Follow the guideline in their repository.

```
# sync on local file system
repository:
  type: file
  # path of the local directory to sync with, required
  path: ~/Development/settings
```

The key is to change the path to the directory you want (e.g. `~/.dotfiles/vscode`).

### Backup

> Sync Settings: Upload (user -> repository)

### Restore

> Sync Settings: Download (repository -> user)
