{ pkgs, ... }: {
  home.packages = with pkgs; [ captive-browser ];
}
