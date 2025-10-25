{ system, pkgs, ... }: {
  home.stateVersion = "25.11";
  home.username = "yuxqiu";
  home.homeDirectory = if pkgs.lib.hasInfix "darwin" system then
    "/Users/yuxqiu"
  else
    "/home/yuxqiu";
  news.display = "silent";
}
