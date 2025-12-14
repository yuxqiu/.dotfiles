#!/bin/bash

# Exit on error
set -e

# Asahi specifics
plymouth_packages=(
    plymouth
    plymouth-scripts
    plymouth-theme-asahi
)

# Main function to process a package
process_package() {
    local pkg="$1"

    # Check if package is already installed
    if rpm -q "$pkg" >/dev/null 2>&1; then
        echo "Package $pkg is already installed"
        return
    fi

    echo "Installing $pkg from Fedora repositories..."
    sudo dnf install -y "$pkg" || { echo "Failed to install $pkg"; exit 1; }
}

# Detect if this is Fedora Asahi
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" != "fedora-asahi-remix" ]]; then
    echo "Skipped because of unsupported system (not Fedora Asahi)"
    exit 0
    fi
else
    echo "Skipped because of unsupported system (no /etc/os-release)"
    exit 0
fi

# Process all packages from plymouth_packages
echo "Installing all defined packages..."
for pkg in "${plymouth_packages[@]}"; do
    process_package "$pkg"
done
echo "Package processing completed."

echo "Checking Plymouth theme..."

# Get the current default theme (plymouth-set-default-theme prints it if no args)
current_theme=$(plymouth-set-default-theme 2>/dev/null || echo "none")

if [[ "$current_theme" == "asahi" ]]; then
    echo "Plymouth theme is already set to 'asahi' - skipping"
else
    echo "Setting Plymouth theme to 'asahi'..."
    sudo plymouth-set-default-theme -R asahi
    echo "Plymouth theme set to 'asahi' and initramfs rebuilt."
fi
