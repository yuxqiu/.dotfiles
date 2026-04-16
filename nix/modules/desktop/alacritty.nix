{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      # momeemt/config/nix/profiles/hm/programs/alacritty/settings/hints.nix
      open-zed = pkgs.writeShellApplication {
        name = "open-zed";
        runtimeInputs = with pkgs; [
          coreutils
          zed-editor
        ];
        text = ''
          set -euo pipefail

          if [ "$#" -lt 1 ]; then
            echo "Usage: open-zed [PATHS_WITH_POSITION]" >&2
            exit 1
          fi

          raw_path="$1"
          raw_path="$(echo "$raw_path" | xargs)"

          # shellcheck disable=SC2088
          if [ "$raw_path" = "~" ] || [[ "$raw_path" == "~/"* ]]; then
            raw_path="$HOME''${raw_path:1}"
          fi

          zeditor "$raw_path"
        '';
      };
      exec-arg = pkgs.writeShellApplication {
        name = "exec-arg";
        runtimeInputs = with pkgs; [ tmux ];
        text = ''
          cmd="$1"
          tmux send-keys "$cmd" Enter
        '';
      };
    in
    {
      programs.alacritty = {
        enable = true;

        settings = {
          env = {
            TERM = "xterm-256color";
          };

          scrolling = {
            history = 10000;
            multiplier = 3;
          };

          window = {
            dynamic_padding = false;
            blur = true;
            dimensions = {
              columns = 120;
              lines = 30;
            };
            padding = {
              x = 10;
              y = 23;
            };
          };

          general = {
            live_config_reload = true;
          };

          hints = {
            enabled = [
              {
                regex = ''(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
                post_processing = true;
                hyperlinks = true;
                command = if pkgs.stdenv.isLinux then "xdg-open" else "open";
                binding = {
                  key = "O";
                  mods = "Control|Shift";
                };
                mouse = {
                  enabled = true;
                  mods = if pkgs.stdenv.isLinux then "Control" else "Command";
                };
              }
              {
                regex = ''([\\w./~-][^\\s]*\\.[a-zA-Z0-9]+)(?::(\\d+):(\\d+))?'';
                post_processing = true;
                command = "${open-zed}/bin/open-zed";
                binding = {
                  key = "E";
                  mods = "Control|Shift";
                };
                mouse = {
                  enabled = true;
                  mods = if pkgs.stdenv.isLinux then "Control" else "Command";
                };
              }
              {
                regex = ''(nix log /nix/store/[^\\s]+)'';
                post_processing = true;
                command = "${exec-arg}/bin/exec-arg";
                binding = {
                  key = "L";
                  mods = "Control|Shift";
                };
              }
            ];
          };
        };
      };
    };

  flake.modules.homeManager.linux-desktop =
    { lib, ... }:
    {
      wayland.windowManager.niri.settings.binds."Mod+Return" = {
        _props.hotkey-overlay-title = "Open a Terminal: alacritty";
        spawn = "alacritty";
      };

      wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
        {
          match = {
            _props."app-id" = "Alacritty";
          };

          background-effect.blur = true;
        }
      ];
    };

  flake.modules.homeManager.linux-base = {
    xdg.terminal-exec = {
      settings = {
        default = [
          "Alacritty.desktop"
        ];
      };
    };
  };
}
