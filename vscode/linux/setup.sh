#!/bin/bash

# Define paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
CODE_FILE="code"
BIN_DIR="/usr/local/bin/code"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_FILE="$CONFIG_DIR/code-flags.conf"

# Create symlink for the code file
echo "Creating symlink for the code file at $BIN_DIR..."
sudo ln -sf "$SCRIPT_DIR/$CODE_FILE" "$BIN_DIR"
echo "Symlink created at $BIN_DIR."

# Create symlink for the code-flags.conf file
echo "Creating symlink for the code-flags.conf file at $CONFIG_FILE..."
mkdir -p "$CONFIG_DIR"
ln -sf "$SCRIPT_DIR/code-flags.conf" "$CONFIG_FILE"
echo "Symlink created at $CONFIG_FILE."

echo "Setup completed successfully!"
