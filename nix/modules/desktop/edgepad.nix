{ inputs, ... }:
{
  flake.modules.nixos.edgepad = {
    imports = [ inputs.edgepad.nixosModules.default ];

    services.edgepad.enable = true;
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

      # Pick external (USB) touchpad if present, fall back to internal.
      edgepad-wrapper = pkgs.writeShellApplication {
        name = "edgepad-wrapper";
        text = ''
          set -euo pipefail

          external=""
          internal=""
          for node in /dev/input/event*; do
            [ -e "$node" ] || continue
            props=$(${udevadm} info --query=property "$node" 2>/dev/null || true)
            echo "$props" | grep -q 'ID_INPUT_TOUCHPAD=1' || continue
            if echo "$props" | grep -qE 'ID_BUS=(usb|bluetooth)'; then
              external="$node"
            else
              internal="$node"
            fi
          done

          device="''${external:-$internal}"
          if [ -z "$device" ]; then
            echo "edgepad-wrapper: no touchpad found" >&2
            exit 1
          fi

          exec ${edgepadExe} daemon --config "${configPath}" --device "$device"
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

      systemd.user.services.edgepad.Service.ExecStart = lib.mkForce (lib.getExe edgepad-wrapper);
    };
}
