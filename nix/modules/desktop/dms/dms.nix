{
  inputs,
  ...
}:
{
  flake.modules.homeManager.dms =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.homeModules.default
        inputs.danksearch.homeModules.dsearch
        inputs.dankcalendar.homeModules.dank-calendar
      ];

      programs.dsearch.enable = true;
      programs.dank-material-shell = {
        enable = true;
        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableSystemMonitoring = true;
        enableVPN = true;
        enableDynamicTheming = false;
        enableAudioWavelength = true;
        enableCalendarEvents = false;
        enableClipboardPaste = true;

        plugins = {
          dankActions.enable = true;
          dankLauncherKeys.enable = true;
          emojiLauncher.enable = true;
          calculator.enable = true;
          dankPomodoroTimer = {
            enable = true;
            settings = {
              workDuration = 45;
            };
          };
          powerOptions = {
            enable = true;
            settings = {
              noTrigger = true;
              trigger = "";
            };
          };
          screenCaptureToolbar = {
            enable = true;
            settings = {
              saveToDisk = false;
              showNotify = false;
              showPointer = false;
              videoCustomPath = "~/Downloads";
            };
          };
          takeABreak = {
            enable = true;
            settings = {
              shortBreakInterval = 60;
              soundEnabled = false;
              preWarningOpacity = 80;
              overlayOpacity = 80;
            };
          };
        };

        settings = builtins.fromJSON (builtins.readFile ./configs/settings.json) // {
          customThemeFile = "${inputs.dms-plugin-registry}/themes/catppuccin/theme.json";
        };
      };
      programs.dank-calendar = {
        enable = true;
        systemd.enable = true;
      };

      home.packages = with pkgs; [
        slurp
        grim
        satty
        jq
      ];

      # Restart dms service when settings are changed
      systemd.user.services.dms.Unit.X-Restart-Triggers = [
        config.xdg.configFile."DankMaterialShell/settings.json".source
      ];

      wayland.windowManager.niri = {
        settings = {
          config-notification.disable-failed = [ ];

          # Show wallpaper on desktop and overview.
          layout.background-color = "transparent";

          layer-rule = [
            {
              match = {
                _props.namespace = "^quickshell$";
              };
              place-within-backdrop = true;
            }
          ];

          overview.workspace-shadow.off = [ ];

          binds = {
            "Mod+Space" = {
              _props.hotkey-overlay-title = "Application Launcher";
              spawn = [
                "dms"
                "ipc"
                "call"
                "spotlight"
                "toggle"
              ];
            };

            "Mod+V" = {
              _props.hotkey-overlay-title = "Clipboard Manager";
              spawn = [
                "dms"
                "ipc"
                "call"
                "clipboard"
                "toggle"
              ];
            };

            "Mod+Shift+S" = {
              _props.hotkey-overlay-title = "Screen Capture";
              spawn = [
                "dms"
                "ipc"
                "call"
                "screenCaptureToolbar"
                "toggle"
              ];
            };

            "Mod+Shift+O" = {
              _props.hotkey-overlay-title = "Lock Screen";
              spawn = [
                "dms"
                "ipc"
                "call"
                "lock"
                "lock"
              ];
            };

            "XF86AudioRaiseVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "dms"
                "ipc"
                "call"
                "audio"
                "increment"
                "5"
              ];
            };

            "XF86AudioLowerVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "dms"
                "ipc"
                "call"
                "audio"
                "decrement"
                "5"
              ];
            };

            "XF86AudioMute" = {
              _props."allow-when-locked" = true;
              spawn = [
                "dms"
                "ipc"
                "call"
                "audio"
                "mute"
              ];
            };

            "XF86AudioMicMute" = {
              _props."allow-when-locked" = true;
              spawn = [
                "dms"
                "ipc"
                "call"
                "audio"
                "micmute"
              ];
            };

            "XF86MonBrightnessUp" = {
              _props."allow-when-locked" = true;
              spawn-sh = "dms ipc call brightness increment 5 \"$(~/.config/niri/scripts/dms-focused-output)\"";
            };

            "XF86MonBrightnessDown" = {
              _props."allow-when-locked" = true;
              spawn-sh = "dms ipc call brightness decrement 5 \"$(~/.config/niri/scripts/dms-focused-output)\"";
            };
          };
        };
      };

      stylix.targets.dank-material-shell.enable = false;
    };
}
