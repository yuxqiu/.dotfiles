{
  inputs,
  ...
}:
{
  flake.modules.homeManager.linux-desktop = {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.modules.default
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

      plugins = {
        dankBatteryAlerts.enable = true;
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
      };

      settings = builtins.fromJSON (builtins.readFile ./configs/settings.json) // {
        customThemeFile = "${inputs.dms-plugin-registry}/themes/catppuccin/theme.json";
      };
    };
    home.file.".config/niri/dms/dms.kdl".source = ./configs/dms.kdl;

    stylix.targets.dank-material-shell.enable = false;
  };
}
