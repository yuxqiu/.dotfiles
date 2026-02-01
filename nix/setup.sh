#!/bin/bash

# Exit on error
set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./setup.sh <flake-output-name>"
    echo "Example: ./setup.sh yuxqiu-laptop"
    return 1
fi

# Install nix from determinate
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Setup home-manager packages and configs
nix run home-manager/master -- switch --flake ".#$1"

# Setup system packages and configs
sudo ~/.nix-profile/bin/system-manager switch --flake ".#$1"
