{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:

    let
      nerd-dictation = import (inputs.self + /packages/nerd-dictation.nix) { inherit pkgs; };

      dictation-toggle = pkgs.writeShellApplication {
        name = "dictation";
        runtimeInputs = with pkgs; [
          coreutils
          pulseaudio
          libnotify
          procps
          nerd-dictation
        ];

        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          readonly MIC_STATE_FILE="/tmp/nerd-dictation-mic-state"
          readonly NERD_DICTATION="${nerd-dictation}/bin/nerd-dictation"
          readonly PACTL="${pkgs.pulseaudio}/bin/pactl"
          readonly NOTIFY="${pkgs.libnotify}/bin/notify-send"

          get_default_mic() {
            "$PACTL" get-default-source
          }

          is_muted() {
            local source="$1"
            "$PACTL" get-source-mute "$source" | grep -q "Mute: yes"
          }

          unmute() {
            local source="$1"
            "$PACTL" set-source-mute "$source" 0 || {
              "$NOTIFY" "Dictation" "Failed to unmute microphone"
              exit 1
            }
          }

          save_mic_state() {
            local muted="$1"
            printf '%s\n' "$muted" > "$MIC_STATE_FILE"
          }

          restore_mic_state() {
            local source="$1"

            if [[ ! -f "$MIC_STATE_FILE" ]]; then
              return
            fi

            local was_muted
            was_muted=$(<"$MIC_STATE_FILE") || true

            if [[ "$was_muted" == "yes" ]]; then
              "$PACTL" set-source-mute "$source" 1 || true
            fi

            rm -f "$MIC_STATE_FILE"
          }

          mic=$(get_default_mic)

          if pgrep -f nerd-dictation > /dev/null; then
            # ── STOP ─────────────────────────────────────
            "$NERD_DICTATION" end || {
              "$NOTIFY" "Dictation" "Failed to stop nerd-dictation"
              exit 1
            }
            restore_mic_state "$mic"
            "$NOTIFY" "Dictation" "Dictation stopped"
          else
            # ── START ─────────────────────────────────────
            if is_muted "$mic"; then
              save_mic_state "yes"
              unmute "$mic"
            else
              save_mic_state "no"
            fi

            "$NERD_DICTATION" begin --simulate-input-tool=DOTOOL &

            # Give it a moment to start
            sleep 0.3

            if ! pgrep -f nerd-dictation > /dev/null; then
              "$NOTIFY" "Dictation" "Failed to start dictation"
              restore_mic_state "$mic"
              exit 1
            fi

            "$NOTIFY" "Dictation" "Dictation started — speak now"
          fi
        '';
      };

    in
    {
      home.file.".config/niri/scripts/dictation" = {
        source = "${dictation-toggle}/bin/dictation";
        executable = true;
      };
    };
}
