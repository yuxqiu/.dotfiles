{ pkgs, ... }: {
  home.packages = with pkgs; [ nixfmt nixd ];
  home.stateVersion = "25.05";
}
