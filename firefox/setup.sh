#!/bin/bash

# Exit on error
set -e

# Define paths
SCRIPT_DIR=$(dirname "$(realpath "$0")")
FIREFOX_DIR="$HOME/.mozilla/firefox"
THEMES_DIR="$FIREFOX_DIR/firefox-themes"
ARKENFOX_URL="https://raw.githubusercontent.com/arkenfox/user.js/master/user.js"
WHITESUR_URL="https://github.com/vinceliuice/WhiteSur-firefox-theme/archive/refs/heads/main.tar.gz"
USER_JS="user.js"
USER_OVERRIDE_JS="user-override.js"
CUSTOM_CHROME_CSS="customChrome.css"
CUSTOM_CONTENT_CSS="customContent.css"

# Find the default Firefox profile directory
# Look for profiles.ini and extract the Path of the profile with Default=1
if [ ! -f "$FIREFOX_DIR/profiles.ini" ]; then
  echo "Error: profiles.ini not found in $FIREFOX_DIR"
  exit 1
fi

# Parse profiles.ini to find the profile with Default=1
PROFILE_PATH=$(awk '
  /^\[Profile.*\]/ {profile=""; is_default=0}  # Start of a Profile section
  /Path=/ {profile=substr($0, index($0, "=")+1)}  # Capture Path
  /Default=1/ {is_default=1}  # Mark if Default=1
  is_default && profile {print profile; exit}  # Print Path if default
' "$FIREFOX_DIR/profiles.ini")

if [ -z "$PROFILE_PATH" ]; then
  echo "Error: Could not find default profile path in profiles.ini"
  exit 1
fi

FULL_PROFILE_PATH="$FIREFOX_DIR/$PROFILE_PATH"
CHROME_DIR="$FULL_PROFILE_PATH/chrome"

# Ensure the profile directory exists
if [ ! -d "$FULL_PROFILE_PATH" ]; then
  echo "Error: Profile directory $FULL_PROFILE_PATH does not exist"
  exit 1
fi

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

# Prompt for updating user.js
if prompt_with_timeout "Do you want to update user.js with arkenfox and append user-override.js?" "n"; then
  # Download arkenfox user.js
  echo "Downloading arkenfox user.js..."
  curl -s -o "$FULL_PROFILE_PATH/$USER_JS" "$ARKENFOX_URL"
  if [ ! -f "$FULL_PROFILE_PATH/$USER_JS" ]; then
    echo "Error: Failed to download user.js"
    exit 1
  fi

  # Append user-override.js to user.js if user-override.js exists
  echo "Appending $USER_OVERRIDE_JS to $USER_JS..."
  cat "$SCRIPT_DIR/$USER_OVERRIDE_JS" >> "$FULL_PROFILE_PATH/$USER_JS"
else
  echo "Skipping user.js update"
fi

# Prompt for installing WhiteSur Firefox theme
if prompt_with_timeout "Do you want to install the WhiteSur Firefox theme (alt variant, firefox will restart)?" "n"; then
  # Remove existing chrome directory if it exists
  if [ -d "$CHROME_DIR" ]; then
    echo "Removing existing chrome directory at $CHROME_DIR..."
    rm -rf "$CHROME_DIR"
  fi

  # Download and extract WhiteSur theme
  echo "Downloading WhiteSur Firefox theme..."
  curl -s -L -o whitesur.tar.gz "$WHITESUR_URL"
  tar -xzf whitesur.tar.gz
  cd WhiteSur-firefox-theme-main

  # Install the alt theme
  echo "Installing WhiteSur alt theme..."
  ./install.sh -t alt -n whitesur -p firefox
  cd ..

  # Clean up
  rm -rf WhiteSur-firefox-theme-main whitesur.tar.gz

  # Ensure chrome directory exists
  mkdir -p "$CHROME_DIR"

  # Append CSS imports to userChrome.css and userContent.css
  if [ -f "$CHROME_DIR/userChrome.css" ]; then
    echo "Appending @import for $CUSTOM_CHROME_CSS to userChrome.css..."
    if ! grep -Fx "@import \"$CUSTOM_CHROME_CSS\";" "$CHROME_DIR/userChrome.css" > /dev/null; then
      echo "@import \"$CUSTOM_CHROME_CSS\";" >> "$CHROME_DIR/userChrome.css"
    else
      echo "$CUSTOM_CHROME_CSS already imported in userChrome.css"
    fi
  else
    echo "Creating userChrome.css and adding @import for $CUSTOM_CHROME_CSS..."
    echo "@import \"$CUSTOM_CHROME_CSS\";" > "$CHROME_DIR/userChrome.css"
  fi

  if [ -f "$CHROME_DIR/userContent.css" ]; then
    echo "Appending @import for $CUSTOM_CONTENT_CSS to userContent.css..."
    if ! grep -Fx "@import \"$CUSTOM_CONTENT_CSS\";" "$CHROME_DIR/userContent.css" > /dev/null; then
      echo "@import \"$CUSTOM_CONTENT_CSS\";" >> "$CHROME_DIR/userContent.css"
    else
      echo "$CUSTOM_CONTENT_CSS already imported in userContent.css"
    fi
  else
    echo "Creating userContent.css and adding @import for $CUSTOM_CONTENT_CSS..."
    echo "@import \"$CUSTOM_CONTENT_CSS\";" > "$CHROME_DIR/userContent.css"
  fi
else
  echo "Skipping WhiteSur theme installation"
fi

# Symlink customChrome.css and customContent.css to firefox-themes if they exist
mkdir -p "$THEMES_DIR"

# Symlink customChrome.css and customContent.css if they exist
echo "Symlinking $SCRIPT_DIR/$CUSTOM_CHROME_CSS to $THEMES_DIR..."
ln -sf "$SCRIPT_DIR/$CUSTOM_CHROME_CSS" "$THEMES_DIR/$CUSTOM_CHROME_CSS"

echo "Symlinking $SCRIPT_DIR/$CUSTOM_CONTENT_CSS to $THEMES_DIR..."
ln -sf "$SCRIPT_DIR/$CUSTOM_CONTENT_CSS" "$THEMES_DIR/$CUSTOM_CONTENT_CSS"

echo "Firefox setup completed successfully!"
