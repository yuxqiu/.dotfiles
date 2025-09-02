#!/bin/bash

# Exit on error
set -e

# Define paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
SDDM_THEMES_DIR="/usr/share/sddm/themes"
CATPPUCCIN_URL="https://github.com/catppuccin/sddm/releases/latest/download/catppuccin-mocha-mauve-sddm.zip"
CATPPUCCIN_ZIP="catppuccin-mocha-mauve-sddm.zip"
CATPPUCCIN_THEME_DIR="$SDDM_THEMES_DIR/catppuccin-mocha-mauve"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_CONF_FILE="$SDDM_CONF_DIR/catppuccin.conf"

# Function to prompt with timeout
prompt_with_timeout() {
  local prompt="$1"
  local default_answer="$2"
  local timeout=5
  local answer

  echo -n "$prompt (y/n, default $default_answer in $timeout seconds): "
  if read -t $timeout answer; then
    case "$answer" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "Invalid input, using default ($default_answer)"; return $([ "$default_answer" = "y" ] && echo 0 || echo 1) ;;
    esac
  else
    echo "Timeout, using default ($default_answer)"
    return $([ "$default_answer" = "y" ] && echo 0 || echo 1)
  fi
}

# Create SDDM configuration directory if it doesn't exist
if [ ! -d "$SDDM_CONF_DIR" ]; then
  echo "Creating SDDM configuration directory at $SDDM_CONF_DIR..."
  sudo mkdir -p "$SDDM_CONF_DIR"
fi

# Prompt for downloading and installing Catppuccin SDDM theme
if prompt_with_timeout "Do you want to download and install the Catppuccin Mocha Mauve SDDM theme?" "n"; then
  # Ensure themes directory exists
  if [ ! -d "$SDDM_THEMES_DIR" ]; then
    echo "Creating SDDM themes directory at $SDDM_THEMES_DIR..."
    sudo mkdir -p "$SDDM_THEMES_DIR"
  fi

  # Download Catppuccin theme
  echo "Downloading Catppuccin Mocha Mauve SDDM theme..."
  curl -s -L -o "$CATPPUCCIN_ZIP" "$CATPPUCCIN_URL"
  if [ ! -f "$CATPPUCCIN_ZIP" ]; then
    echo "Error: Failed to download $CATPPUCCIN_ZIP"
    exit 1
  fi

  # Remove existing theme directory if it exists
  if [ -d "$CATPPUCCIN_THEME_DIR" ]; then
    echo "Removing existing Catppuccin theme directory at $CATPPUCCIN_THEME_DIR..."
    sudo rm -rf "$CATPPUCCIN_THEME_DIR"
  fi

  # Unzip and move the theme
  echo "Unzipping Catppuccin theme..."
  unzip -q "$CATPPUCCIN_ZIP" -d catppuccin-mocha-mauve
  echo "Moving Catppuccin theme to $SDDM_THEMES_DIR..."
  sudo mv ./catppuccin-mocha-mauve/catppuccin-mocha-mauve "$SDDM_THEMES_DIR/"
  rm -rf ./catppuccin-mocha-mauve

  # Clean up
  rm -rf "$CATPPUCCIN_ZIP"

  # Create or update SDDM configuration file
  echo "Creating SDDM configuration file at $SDDM_CONF_FILE..."
  sudo bash -c "cat > $SDDM_CONF_FILE" << EOL
[Theme]
Current=catppuccin-mocha-mauve
EOL
else
  echo "Skipping Catppuccin theme installation"
fi

# Symlink all .conf files in the script directory to SDDM themes directory
for conf_file in "$SCRIPT_DIR"/*.conf; do
  if [ -f "$conf_file" ]; then
    conf_basename=$(basename "$conf_file")
    echo "Symlinking $conf_file to $SDDM_CONF_DIR..."
    sudo ln -sf "$conf_file" "$SDDM_CONF_DIR/$conf_basename"
  fi
done

echo "SDDM setup completed successfully!"
