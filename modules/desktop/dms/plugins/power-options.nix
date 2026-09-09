{
  flake.modules.homeManager.dms = {
    programs.dank-material-shell.plugins.powerOptions = {
      enable = true;
      settings = {
        noTrigger = true;
        trigger = "";
      };
    };
  };
}
