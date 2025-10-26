#!/bin/bash

# Exit on error
set -e

# Install nix from determinate
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Install home manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
nix-env -iA home-manager.home-manager

# Add trusted cache mirror in China
sudo echo "trusted-substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store" >> /etc/nix/nix.custom.conf

# Setup nix packages and configs
home-manager switch --flake .#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')

# Cleanup nix
home-manager expire-generations now && nix-collect-garbage
