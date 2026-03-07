#!/usr/bin/env bash

set -euo pipefail

#=============================================================================
# Copied from https://gist.github.com/ahmedna126/884b524e50b43db92caaec0ca55b6976
#=============================================================================

SCRIPT="$HOME/.config/niri/scripts/niri-floating-sidebar.sh"

niri msg event-stream | while read -r line; do
    case "$line" in
        *"Window closed"*)
            # Window was closed → resync sidebar
            "$SCRIPT" reorder >/dev/null 2>&1 || true
            ;;
    esac
done
