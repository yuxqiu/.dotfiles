#!/bin/bash

# Exit on error
set -e

# Disable SELinux if it is installed and enabled
if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
    echo "SELinux is present and not disabled. Disabling it permanently..."

    # Disable at kernel level
    sudo grubby --update-kernel ALL --args selinux=0

    # Also update the config file
    if [ -f /etc/selinux/config ]; then
        sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    fi

    echo "SELinux has been disabled. A reboot is required for changes to take full effect."
fi
