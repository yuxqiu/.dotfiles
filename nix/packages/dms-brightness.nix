{
  lib,
  writeShellApplication,
  niri-focused-output,
}:
writeShellApplication {
  name = "dms-brightness";
  runtimeInputs = [ niri-focused-output ];
  text = ''
    set -euo pipefail

    action="$1" # "increment" or "decrement"
    amount="''${2:-1}"

    bus=$(niri-focused-output)
    output=""
    if [ -n "$bus" ]; then
      output="ddc:i2c-$bus"
    fi

    # NOTE: DDC/CI over i2c is inherently slow (~200-500ms per setvcp).
    # niri-focused-output caches the bus detection to avoid redundant
    # probes, but the write latency is unavoidable for external monitors.
    exec dms ipc call brightness "$action" "$amount" "$output"
  '';

  meta = {
    description = "Adjust brightness of the focused niri output via DMS IPC (shows DMS OSD)";
    platforms = lib.platforms.linux;
  };
}
