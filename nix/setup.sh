#!/bin/bash

# Exit on error
set -e

# Install nix from determinate
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-env -iA home-manager.home-manager

# Setup nix packages and configs
sys_name=$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')
home-manager switch --flake .#$sys_name
sudo ~/.nix-profile/bin/system-manager switch --flake .#$sys_name

# Cleanup nix
home-manager expire-generations now && nix-collect-garbage
