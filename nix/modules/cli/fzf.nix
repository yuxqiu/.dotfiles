{
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    # use terminal's colors/transparency/blur instead
    programs.fzf.colors = {
      bg = "-1";
      "bg+" = "-1";
      "preview-bg" = "-1";
    };
    stylix.targets.fzf.colors.enable = false;
  };
}
