{ pkgs, ... }:

let
  dms-focused-output = pkgs.writeShellScriptBin "dms-focused-output" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # Get the raw output name niri sees
    name=$(niri msg --json focused-output | ${pkgs.jq}/bin/jq -r '.name')

    # If it's any kind of built-in panel, let dms use its backlight default
    if [[ "$name" == eDP-* || "$name" == LVDS-* || "$name" == backlight:* ]]; then
      exit 0
    fi

    # Otherwise it's an external monitor, force DDC/I2C
    for i in {2..10}; do
      if ${pkgs.ddcutil}/bin/ddcutil --bus=$i getvcp 10 >/dev/null 2>&1; then
        echo "ddc:i2c-$i"
        exit 0
      fi
    done
  '';

in { home.packages = [ dms-focused-output ]; }
