{ pkgs, ... }: {
  home.packages = with pkgs; [ fzf ];

  programs.fzf = {
    enable = true; # enables fzf installation
    enableZshIntegration = true; # for Zsh
  };
}
