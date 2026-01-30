#!/bin/bash

# Exit on error
set -e

# Install nix from determinate
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Setup home-manager packages and configs
sys_name=$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')
nix run home-manager/master -- switch --flake .#$sys_name

# Setup system packages and configs
sudo ~/.nix-profile/bin/system-manager switch --flake .#$sys_name
