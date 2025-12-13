#!/bin/bash

# Exit on error
set -e

# Install nix from determinate
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
nix-env -iA home-manager.home-manager

# Setup nix packages and configs
sys_name=$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')
home-manager switch --flake .#$sys_name
sudo ~/.nix-profile/bin/system-manager switch --flake .#$sys_name

# Cleanup nix
home-manager expire-generations now && nix-collect-garbage

# Post nix
# ========

# Setup i2c group for controlling external monitor
# - Required by `nix/modules/sm/linux/ddcutil.nix`
# - Ref: https://www.ddcutil.com/i2c_permissions_using_group_i2c/
sudo groupadd --system i2c
sudo usermod $USER -aG i2c

# Disable systemd-resolvd
# - Required by `nix/modules/sm/linux/NetworkManager`
# - Ref: https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo systemctl restart NetworkManager
