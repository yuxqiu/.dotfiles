#!/bin/bash

set -e

# Define paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
CODE_FILE="linux/code"
CONFIG_FILE="linux/code-flags.conf"

TARGET_BIN_DIR="/usr/local/bin/code"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_CONFIG_FILE="$TARGET_CONFIG_DIR/code-flags.conf"
TARGET_VSCODE_CONFIG_DIR="$HOME/.config/Code/User"

# Create symlink for the code file
echo "Creating symlink for the code file at $TARGET_BIN_DIR..."
sudo ln -sf "$SCRIPT_DIR/$CODE_FILE" "$TARGET_BIN_DIR"
echo "Symlink created at $TARGET_BIN_DIR."

# Create symlink for the code-flags.conf file
echo "Creating symlink for the code-flags.conf file at $TARGET_CONFIG_FILE..."
mkdir -p "$TARGET_CONFIG_DIR"
ln -sf "$SCRIPT_DIR/$CONFIG_FILE" "$TARGET_CONFIG_FILE"
echo "Symlink created at $TARGET_CONFIG_FILE."

mkdir -p "$TARGET_VSCODE_CONFIG_DIR"

# Create symlink for the snippet files
echo "Creating symlink for the snippet files at $TARGET_VSCODE_CONFIG_DIR/snippets..."
rm -f $TARGET_VSCODE_CONFIG_DIR/snippets
ln -sf $SCRIPT_DIR/snippets $TARGET_VSCODE_CONFIG_DIR/snippets
echo "Symlink created at $TARGET_VSCODE_CONFIG_DIR/snippets."

# Create symlink for the keybindings file
echo "Creating symlink for the keybindings file at $TARGET_VSCODE_CONFIG_DIR/keybindings.json..."
ln -sf $SCRIPT_DIR/keybindings.json $TARGET_VSCODE_CONFIG_DIR/keybindings.json
echo "Symlink created at $TARGET_VSCODE_CONFIG_DIR/keybindings.json."

# Create symlink for the settings file
echo "Creating symlink for the settings file at $TARGET_VSCODE_CONFIG_DIR/settings.json..."
ln -sf $SCRIPT_DIR/settings.json $TARGET_VSCODE_CONFIG_DIR/settings.json
echo "Symlink created at $TARGET_VSCODE_CONFIG_DIR/settings.json."

# Install extensions
bash $SCRIPT_DIR/extensions.sh

echo "Setup completed successfully!"
