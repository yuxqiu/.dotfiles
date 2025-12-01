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
  flatpak
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
  usbmuxd
  wireplumber
  xdg-desktop-portal-gtk
  xdg-user-dirs
)

# Associative array for packages requiring COPR repositories
declare -A copr_map=(
  ["niri"]="yalter/niri-git"
  ["dms"]="avengemedia/dms"
  ["dms-greeter"]="avengemedia/dms"
)

# Associative array for packages requiring manual RPM downloads
declare -A rpm_map=(
  # opensnitch is managed here because dark theme of nixpkgs version is broken
  ["opensnitch"]="https://github.com/evilsocket/opensnitch/releases/download/v1.7.2/opensnitch-1.7.2-1.$(uname -m).rpm"
  ["opensnitch-ui"]="https://github.com/evilsocket/opensnitch/releases/download/v1.7.2/opensnitch-ui-1.7.2-1.noarch.rpm"
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

# Function to download and install an RPM
install_rpm() {
  local rpm_url="$1"
  local temp_dir=$(mktemp -d)
  local rpm_file="${temp_dir}/package.rpm"

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
  # Check if package is in RPM map
  elif [[ -n "${rpm_map[$pkg]}" ]]; then
    install_rpm "${rpm_map[$pkg]}"
  else
    echo "Error: Package $pkg not found in any package list or map"
    exit 1
  fi
}

# Process all packages from fedora_packages, copr_map, docker_map and rpm_map
echo "Installing all defined packages..."
for pkg in "${fedora_packages[@]}" "${!copr_map[@]}" "${!docker_map[@]}" "${!rpm_map[@]}"; do
  process_package "$pkg"
done

echo "Package processing completed."
