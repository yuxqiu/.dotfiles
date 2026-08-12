{ inputs, ... }:
{
  flake.modules.nixos.edgepad = {
    imports = [ inputs.edgepad.nixosModules.default ];

    services.edgepad.enable = true;

    # Tag edgepad's virtual touchpad as external so libinput doesn't
    # disable it when the laptop lid is closed.
    services.udev.extraRules = ''
      ACTION=="add", KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_INPUT_TOUCHPAD}=="1", ATTRS{name}=="edgepad virtual touchpad", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="external"
    '';
  };

  flake.modules.homeManager.edgepad =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.services.edgepad;
      edgepadExe = lib.getExe cfg.package;
      configPath = "${config.xdg.configHome}/edgepad/edgepad.toml";
      udevadm = "${pkgs.systemd}/bin/udevadm";
      niri-focused-output = pkgs.callPackage (inputs.self + /packages/niri-focused-output.nix) { };
      dms-brightness = pkgs.callPackage (inputs.self + /packages/dms-brightness.nix) {
        inherit niri-focused-output;
      };

      # Pick external (USB/Bluetooth) touchpad if present, fall back to internal.
      # Supervises edgepad and switches devices on hot-plug via inotify.
      edgepad-wrapper = pkgs.writeShellApplication {
        name = "edgepad-wrapper";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.inotify-tools
        ];
        text = ''
          set -euo pipefail

          pick_device() {
            local external=""
            local internal=""
            for node in /dev/input/event*; do
              [ -e "$node" ] || continue
              props=$(${udevadm} info --query=property "$node" 2>/dev/null || true)
              echo "$props" | grep -q 'ID_INPUT_TOUCHPAD=1' || continue
              # Skip edgepad's own virtual device (DEVPATH=/devices/virtual/input/...)
              echo "$props" | grep -q 'DEVPATH=/devices/virtual/input/' && continue
              if echo "$props" | grep -qE 'ID_BUS=(usb|bluetooth)'; then
                external="$node"
              else
                internal="$node"
              fi
            done
            echo "''${external:-$internal}"
          }

          current_device=""
          edgepad_pid=""
          edgepad_fifo=""
          reader_pid=""

          cleanup() {
            [ -n "''${reader_pid:-}" ] && kill "$reader_pid" 2>/dev/null || true
            [ -n "''${edgepad_pid:-}" ] && kill "$edgepad_pid" 2>/dev/null || true
            [ -n "''${edgepad_fifo:-}" ] && rm -f "$edgepad_fifo"
            exit 0
          }
          trap cleanup TERM INT

          forward_reload() {
            [ -n "''${edgepad_pid:-}" ] && kill -HUP "$edgepad_pid" 2>/dev/null || true
          }
          trap forward_reload HUP

          # shellcheck disable=SC2094
          start_edgepad() {
            current_device=$(pick_device)
            if [ -z "$current_device" ]; then
              return 1
            fi

            # FIFO to read edgepad's output; $! gives edgepad's real PID
            edgepad_fifo=$(mktemp -u /tmp/edgepad-fifo.XXXXXX)
            mkfifo "$edgepad_fifo"
            ${edgepadExe} daemon --config "${configPath}" --device "$current_device" >"$edgepad_fifo" 2>&1 &
            edgepad_pid=$!

            # Read edgepad output line-by-line, react to startup messages
            while IFS= read -r line; do
              echo "$line" >&2
              case "$line" in
                *"already touched"*)
                  # Fingers were on the trackpad — kill and signal retry
                  kill "$edgepad_pid" 2>/dev/null || true
                  wait "$edgepad_pid" 2>/dev/null || true
                  rm -f "$edgepad_fifo"
                  edgepad_fifo=""
                  return 1
                  ;;
                *"ready notification sent"*)
                  # edgepad is ready — background reader keeps FIFO drained
                  while IFS= read -r line; do
                    echo "$line" >&2
                  done <"$edgepad_fifo" &
                  reader_pid=$!
                  return 0
                  ;;
              esac
            done <"$edgepad_fifo"

            # edgepad exited before printing either message
            rm -f "$edgepad_fifo"
            edgepad_fifo=""
            return 1
          }

          restart_edgepad() {
            [ -n "''${reader_pid:-}" ] && kill "$reader_pid" 2>/dev/null || true
            [ -n "''${edgepad_pid:-}" ] && kill "$edgepad_pid" 2>/dev/null || true
            wait "$edgepad_pid" 2>/dev/null || true
            [ -n "''${edgepad_fifo:-}" ] && rm -f "$edgepad_fifo"
            while ! start_edgepad; do
              sleep 1
            done
          }

          # Initial start (retry until a device is found and not "already touched")
          while ! start_edgepad; do
            sleep 1
          done

          # Watch /dev/input for device add/remove events.
          # If edgepad crashes without a device change, systemd's
          # Restart=on-failure restarts the whole wrapper.
          inotifywait -m -e create,delete /dev/input |
          while IFS= read -r _line; do
            # Brief settle for udev to populate device properties
            sleep 0.2

            # edgepad died (e.g. device removed) — restart with new device
            if ! kill -0 "$edgepad_pid" 2>/dev/null; then
              [ -n "''${reader_pid:-}" ] && kill "$reader_pid" 2>/dev/null || true
              [ -n "''${edgepad_fifo:-}" ] && rm -f "$edgepad_fifo"
              while ! start_edgepad; do
                sleep 1
              done
              continue
            fi

            # A different device appeared — switch
            new_device=$(pick_device)
            if [ -n "$new_device" ] && [ "$new_device" != "$current_device" ]; then
              restart_edgepad
            fi
          done
        '';
      };

    in
    {
      imports = [ inputs.edgepad.homeManagerModules.default ];

      services.edgepad = {
        enable = true;
        device = "auto";
        edgeWidth = 0.05;
        tapMinDurationMs = 40;
        swipeMinDistance = 0.02;

        gestures = [
          {
            zone = "top";
            direction = "tap";
            action = [
              "${pkgs.playerctl}/bin/playerctl"
              "play-pause"
            ];
          }
        ];

        sliders = [
          {
            zone = "left";
            up = [
              "${pkgs.pamixer}/bin/pamixer"
              "-i"
              "1"
            ];
            down = [
              "${pkgs.pamixer}/bin/pamixer"
              "-d"
              "1"
            ];
          }
          {
            zone = "right";
            up = [
              (lib.getExe dms-brightness)
              "increment"
            ];
            down = [
              (lib.getExe dms-brightness)
              "decrement"
            ];
          }
        ];
      };

      systemd.user.services.edgepad.Service = {
        ExecStart = lib.mkForce (lib.getExe edgepad-wrapper);
        # edgepad runs as a child of the wrapper; allow it to send sd_notify
        NotifyAccess = lib.mkForce "all";
      };
    };
}
