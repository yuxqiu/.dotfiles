{ pkgs, ... }:

let
  dms-focused-output = pkgs.writeShellScriptBin "dms-focused-output" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    PATH=${pkgs.lib.makeBinPath [ pkgs.ddcutil pkgs.jq pkgs.coreutils ]}:$PATH

    focused_connector=$(niri msg --json focused-output | jq -r '.name')

    # Built-in laptop panel, let dms use the normal backlight interface
    if [[ "$focused_connector" == eDP-* || "$focused_connector" == LVDS-* ]]; then
      exit 0
    fi

    # Find sysfs entry for the focused connector
    shopt -s nullglob
    candidates=(/sys/class/drm/card*-"$focused_connector")
    shopt -u nullglob

    (( ''${#candidates[@]} == 0 )) && exit 0
    dir="''${candidates[0]}"

    # Modern layout (kernel ≥ 5.17): ./ddc/i2c-dev/i2c-*
    for i2c_path in "$dir"/ddc/i2c-dev/i2c-*; do
      [[ -d "$i2c_path" ]] || continue
      bus=$(cut -d: -f2 < "$i2c_path/dev")
      if ddcutil --bus="$bus" getvcp 10 >/dev/null 2>&1; then
        echo "ddc:i2c-$bus"
        exit 0
      fi
    done

    # If nothing responded, let dms fall back to its own heuristics
    exit 0
  '';
in { home.packages = [ dms-focused-output ]; }
