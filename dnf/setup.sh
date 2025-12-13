#!/bin/bash

# Ensure dnf-plugins-core is installed
if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
    echo "Installing dnf-plugins-core..."
    sudo dnf install -y dnf-plugins-core || { echo "Failed to install dnf-plugins-core"; exit 1; }
fi

# List of packages available in Fedora repositories
fedora_packages=(
    NetworkManager
    NetworkManager-wifi
    NetworkManager-tui
    bluez
    clang
    cmake
    firewalld
    gcc
    gdb
    gnupg2
    ifuse
    mesa-dri-drivers
    mesa-vulkan-drivers
    pipewire
    pipewire-gstreamer
    pipewire-pulseaudio
    pipewire-utils
    polkit
    stow
    tuned
    tuned-utils
    unzip
    usbmuxd
    wireplumber
    zip
)

# Associative array for packages requiring COPR repositories
declare -A copr_map=(
    ["niri"]="yalter/niri-git"
    ["dms"]="avengemedia/dms-git"
    ["dms-greeter"]="avengemedia/dms-git"
)

# Associative array for packages requiring dynamic GitHub RPM downloads
# Key: package name, Value: "repo|grep_pattern"
#   - repo: GitHub repo in owner/repo format
#   - grep_pattern: pattern to match in the asset filename
FEDORA_VERSION=$(grep -oP '(?<=release )[0-9]+' /etc/fedora-release)
ARCH=$(uname -m)
declare -A dynamic_rpm_map=(
    ["displaylink"]="displaylink-rpm/displaylink-rpm|fedora-$FEDORA_VERSION-displaylink.*$ARCH\\.rpm"
    ["opensnitch"]="evilsocket/opensnitch|opensnitch-.*$ARCH\\.rpm"
    ["opensnitch-ui"]="evilsocket/opensnitch|opensnitch-ui-.*noarch\\.rpm"
)

# Associative array for packages requiring Docker repository
declare -A docker_map=(
    ["docker-buildx-plugin"]="docker"
    ["docker-ce"]="docker"
    ["docker-ce-cli"]="docker"
    ["docker-compose-plugin"]="docker"
)

# Function to enable Docker repository
enable_docker_repo() {
    if ! dnf repolist | grep -q "docker-ce"; then
        echo "Setting up Docker repository..."
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || { echo "Failed to add Docker repo"; exit 1; }
        sudo dnf makecache || { echo "Failed to refresh DNF cache"; exit 1; }
    else
        echo "Docker repository already enabled"
    fi
}

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

# Function to download and install a dynamic RPM from GitHub (no jq needed)
install_dynamic_rpm() {
    local pkg="$1"
    local repo="${dynamic_rpm_map[$pkg]%%|*}"
    local pattern="${dynamic_rpm_map[$pkg]#*|}"

    local fedora_version=$(grep -oP '(?<=release )[0-9]+' /etc/fedora-release)
    local arch=$(uname -m)

    # Replace placeholders in pattern
    local grep_pattern="${pattern//\$FEDORA_VERSION/$fedora_version}"
    grep_pattern="${grep_pattern//\$ARCH/$arch}"

    echo "Fetching latest release assets from $repo for $pkg (pattern: $grep_pattern)..."

    local rpm_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" \
        | grep "browser_download_url.*$grep_pattern" \
        | grep -v "\.src\." \
        | cut -d : -f 2,3 \
        | tr -d ' " ' \
        | head -n1)

    if [[ -z "$rpm_url" ]]; then
        echo "Error: No matching RPM found for $pkg with pattern '$grep_pattern' in the latest release of $repo."
        exit 1
    fi

    echo "Found matching RPM: $rpm_url"

    local temp_dir=$(mktemp -d)
    local rpm_file="${temp_dir}/$(basename "$rpm_url")"
    echo "Downloading RPM from $rpm_url..."
    if command -v curl >/dev/null 2>&1; then
        curl -L -o "$rpm_file" "$rpm_url" || { echo "Failed to download $rpm_url"; rm -rf "$temp_dir"; exit 1; }
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$rpm_file" "$rpm_url" || { echo "Failed to download $rpm_url"; rm -rf "$temp_dir"; exit 1; }
    else
        echo "Error: curl or wget required for downloading RPM"; rm -rf "$temp_dir"; exit 1
    fi

    echo "Installing RPM $rpm_file..."
    sudo dnf install -y "$rpm_file" || { echo "Failed to install RPM"; rm -rf "$temp_dir"; exit 1; }
    rm -rf "$temp_dir"
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

    # Check if package is in Docker map
    elif [[ -n "${docker_map[$pkg]}" ]]; then
        enable_docker_repo
        echo "Installing $pkg from Docker repository..."
        sudo dnf install -y "$pkg" || { echo "Failed to install $pkg"; exit 1; }

    # Check if package is in dynamic RPM map
    elif [[ -n "${dynamic_rpm_map[$pkg]}" ]]; then
        install_dynamic_rpm "$pkg"

    else
        echo "Error: Package $pkg not found in any package list or map"
        exit 1
    fi
}

# Process all packages from fedora_packages, copr_map, docker_map and dynamic_rpm_map
echo "Installing all defined packages..."
for pkg in "${fedora_packages[@]}" "${!copr_map[@]}" "${!docker_map[@]}" "${!dynamic_rpm_map[@]}"; do
    process_package "$pkg"
done

echo "Package processing completed."
