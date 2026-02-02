{
  inputs,
  ...
}:
{
  flake.modules.homeManager.linux-gui =
    { config, ... }:
    {
      imports = [
        ./scripts/_dms-focused-output.nix
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
          dankPomodoroTimer.enable = true;
          powerOptions.enable = true;
        };
      };

      xdg.configFile."DankMaterialShell/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.user.dotfiles}/nix/modules/desktop/dms/settings.json";
    };
}
