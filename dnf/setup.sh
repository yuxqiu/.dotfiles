#!/bin/bash

# Exit on error
set -e

# Ensure dnf-plugins-core is installed
if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
    echo "Installing dnf-plugins-core..."
    sudo dnf install -y dnf-plugins-core || { echo "Failed to install dnf-plugins-core"; exit 1; }
fi

# List of packages available in Fedora repositories
fedora_packages=(
    accountsservice
    NetworkManager
    NetworkManager-wifi
    bluez
    cmake
    fuse
    fuse3
    gcc
    gcc-c++
    gdb
    gnupg2
    greetd
    ifuse
    kvantum
    mesa-dri-drivers
    mesa-vulkan-drivers
    pam
    pipewire
    pipewire-gstreamer
    pipewire-pulseaudio
    pipewire-utils
    polkit
    qt5ct
    qt6ct
    stow
    tuned
    tuned-ppd
    tuned-utils
    udisks2
    unzip
    upower
    usbmuxd
    util-linux
    wireplumber
    zip
)

# Associative array for packages requiring COPR repositories
declare -A copr_map=(
    # Example: ["dms-greeter"]="avengemedia/dms-git"
)

# Packages with custom setup scripts
setup_folders=(
    plymouth
)

# Function to enable a COPR repository
enable_copr() {
    local copr_repo="$1"
    if ! dnf repolist | grep -q "${copr_repo##*/}"; then
        echo "Enabling COPR repository: copr.fedorainfracloud.org/$copr_repo"
        sudo dnf copr enable "$copr_repo" -y || { echo "Failed to enable copr.fedorainfracloud.org/$copr_repo"; exit 1; }
        sudo dnf makecache || { echo "Failed to refresh DNF cache"; exit 1; }
    else
        echo "COPR repository copr.fedorainfracloud.org/$copr_repo already enabled"
    fi
}

# Main function to process a package
process_package() {
    local pkg="$1"

    # Check if package is already installed
    if rpm -q "$pkg" >/dev/null 2>&1; then
        echo "Package $pkg is already installed"
        return
    fi

    # Check if package is in Fedora repositories
    if [[ " ${fedora_packages[*]} " =~ " $pkg " ]]; then
        echo "Installing $pkg from Fedora repositories..."
        sudo dnf install -y "$pkg" || { echo "Failed to install $pkg"; exit 1; }

    # Check if package is in COPR map
    elif [[ -n "${copr_map[$pkg]}" ]]; then
        enable_copr "${copr_map[$pkg]}"
        echo "Installing $pkg from COPR..."
        sudo dnf install -y "$pkg" || { echo "Failed to install $pkg"; exit 1; }

    else
        echo "Error: Package $pkg not found in any package list or map"
        exit 1
    fi
}

run_local_setups() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    echo "Running local setup scripts..."

    for folder in "${setup_folders[@]}"; do
        local full_path="$script_dir/$folder"
        local setup_script="$full_path/setup.sh"

        if [[ ! -d "$full_path" ]]; then
            echo "Warning: Folder '$folder' does not exist - skipping"
            continue
        fi

        if [[ ! -f "$setup_script" ]]; then
            echo "Warning: No setup.sh found in '$folder' - skipping"
            continue
        fi

        echo "Running setup.sh in '$folder'..."
        pushd "$full_path" >/dev/null
        bash "./setup.sh" || { echo "Error: setup.sh failed in '$folder'"; exit 1; }
        popd >/dev/null
    done
}

# Process all packages from fedora_packages and copr_map
echo "Installing all defined packages..."
for pkg in "${fedora_packages[@]}" "${!copr_map[@]}"; do
    process_package "$pkg"
done
echo "Package processing completed."

run_local_setups

echo "All package installations and local setups completed."
