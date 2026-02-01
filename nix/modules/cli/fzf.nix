{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
