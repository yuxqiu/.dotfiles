{
  lib,
  writeShellApplication,
  ddcutil,
  jq,
  coreutils,
}:
writeShellApplication {
  name = "niri-focused-output";
  runtimeInputs = [
    ddcutil
    jq
    coreutils
  ];
  text = ''
    set -euo pipefail

    cache_file="/tmp/niri-focused-output.cache"
    cache_ttl=2 # seconds; slider bursts reuse the cached bus

    focused_connector=$(niri msg --json focused-output | jq -r '.name')

    # Built-in laptop panel - no DDC bus
    if [[ "$focused_connector" == eDP-* || "$focused_connector" == LVDS-* ]]; then
      exit 0
    fi

    # Cache hit: same connector within TTL
    if [[ -f "$cache_file" ]]; then
      cached_connector=$(head -1 < "$cache_file" 2>/dev/null || true)
      cached_bus=$(tail -1 < "$cache_file" 2>/dev/null || true)
      if [[ "$cached_connector" == "$focused_connector" && -n "$cached_bus" ]]; then
        if [[ $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0))) -le $cache_ttl ]]; then
          echo "$cached_bus"
          exit 0
        fi
      fi
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
        echo "$bus"
        printf '%s\n%s\n' "$focused_connector" "$bus" > "$cache_file"
        exit 0
      fi
    done

    exit 0
  '';

  meta = {
    description = "Find the DDC bus for the focused niri output (empty for internal panels)";
    platforms = lib.platforms.linux;
  };
}
