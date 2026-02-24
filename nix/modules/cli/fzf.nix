{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    # use terminal's colors/transparency/blur instead
    stylix.targets.fzf.colors.enable = false;
  };
}
