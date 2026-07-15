{
  flake.modules.homeManager.dms = {
    programs.dank-material-shell.plugins.takeABreak = {
      enable = true;
      settings = {
        shortBreakInterval = 60;
        soundEnabled = false;
        preWarningOpacity = 80;
        overlayOpacity = 80;
      };
    };
  };
}
