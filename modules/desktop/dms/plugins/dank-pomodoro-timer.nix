{
  flake.modules.homeManager.dms = {
    programs.dank-material-shell.plugins.dankPomodoroTimer = {
      enable = true;
      settings = {
        workDuration = 45;
      };
    };
  };
}
