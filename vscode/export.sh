#!/bin/bash

set -e

# If called with --list-only, output only the extension list
if [ "$1" = "--list-only" ]; then
  code --list-extensions | sort
  exit 0
fi

# Output full extensions.sh script
cat << EOF
#!/bin/bash

set -e

SCRIPT_DIR=\$(dirname "\$(realpath "\$0")")
EXPORT_SCRIPT="\$SCRIPT_DIR/export.sh"

# List of extensions to install
EXTENSIONS=(
$(code --list-extensions | sort | sed 's/^/  /')
)

# Get installed extensions
if [ -f "\$EXPORT_SCRIPT" ]; then
  INSTALLED_EXTENSIONS=\$(bash "\$EXPORT_SCRIPT" --list-only)
else
  echo "Error: \$EXPORT_SCRIPT not found."
  exit 1
fi

# Install only not-yet-installed extensions
for ext in "\${EXTENSIONS[@]}"; do
  if ! echo "\$INSTALLED_EXTENSIONS" | grep -q "^\$ext\$"; then
    echo "Installing extension: \$ext"
    code --install-extension "\$ext"
  else
    echo "Extension \$ext already installed."
  fi
done

echo "Extension installation check completed."
EOF
