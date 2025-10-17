#!/bin/bash

# Exit on error
set -e

# Define directories with custom setup scripts. Order is important:
# - dirs inside must be kept in the same order, and,
# - custom setup scripts must be ran at the beginning of this setup script
custom_dirs=(
  dnf
  nix
  dms
)

# Define directories to stow with regular stow targeting $HOME
dirs=(
  niri
)

# Define directories to stow with sudo targeting /
sudo_dirs=(
  howdy
  network-manager
  dnf
)

# Define directories to copy directly
copy_dirs=(
  logind
  journald
  earlyoom
  dnscrypt
)

# Define target locations for copy_dirs
declare -A copy_targets
copy_targets=(
  ["logind"]="/etc/systemd"
  ["journald"]="/etc/systemd"
  ["earlyoom"]="/etc/default"
)

# Process custom setup directories
for dir in "${custom_dirs[@]}"; do
  if [ -d "$dir" ] && [ -f "$dir/setup.sh" ]; then
    echo "Running custom setup for $dir..."
    cd "$dir"
    bash setup.sh
    cd ..
  else
    echo "Skipping $dir: directory or setup.sh not found"
  fi
done

# Process regular stow directories
for dir in "${dirs[@]}"; do
  if [ -d "$dir" ]; then
    echo "Stowing $dir to $HOME..."
    stow --target="$HOME" --restow "$dir"
  else
    echo "Skipping $dir: not a directory"
  fi
done

# Process sudo stow directories
for dir in "${sudo_dirs[@]}"; do
  if [ -d "$dir" ]; then
    echo "Stowing $dir to / with sudo..."
    sudo stow --target=/ --restow "$dir"
  else
    echo "Skipping $dir: not a directory"
  fi
done

# Process copy directories
for dir in "${copy_dirs[@]}"; do
  if [ -d "$dir" ]; then
    target="${copy_targets[$dir]}"
    echo "Copying $dir to $target..."
    sudo cp -r "$dir"/* "$target/"
  else
    echo "Skipping $dir: not a directory"
  fi
done

echo "All configurations processed successfully!"
