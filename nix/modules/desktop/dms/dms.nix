{
  inputs,
  ...
}:
{
  flake.modules.homeManager.dms =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dms-focused-output = pkgs.callPackage (inputs.self + /packages/dms-focused-output.nix) { };
    in
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms-plugin-registry.homeModules.default
        inputs.danksearch.homeModules.dsearch
        inputs.dankcalendar.homeModules.dank-calendar
      ];

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

        settings = builtins.fromJSON (builtins.readFile ./configs/settings.json) // {
          customThemeFile = "${inputs.dms-plugin-registry}/themes/catppuccin/theme.json";
        };
      };

      programs.dank-calendar = {
        enable = true;
        systemd.enable = true;
      };

      programs.dsearch.enable = true;

      # Restart dms service when settings are changed
      systemd.user.services.dms.Unit.X-Restart-Triggers = [
        config.xdg.configFile."DankMaterialShell/settings.json".source
      ];

      wayland.windowManager.niri = {
        settings = {
          config-notification.disable-failed = [ ];

          # Show wallpaper on desktop and overview.
          layout.background-color = "transparent";

          _children = lib.mkAfter [
            {
              layer-rule = {
                match._props.namespace = "^quickshell$";
                place-within-backdrop = true;
              };
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
              spawn-sh = "dms ipc call brightness increment 5 \"\$(${dms-focused-output}/bin/dms-focused-output)\"";
            };

            "XF86MonBrightnessDown" = {
              _props."allow-when-locked" = true;
              spawn-sh = "dms ipc call brightness decrement 5 \"\$(${dms-focused-output}/bin/dms-focused-output)\"";
            };
          };
        };
      };

      stylix.targets.dank-material-shell.enable = false;
    };
}
