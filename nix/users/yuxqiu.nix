{ system, pkgs, ... }: {
  home.username = "yuxqiu";
  home.homeDirectory = if pkgs.lib.hasInfix "darwin" system then
    "/Users/yuxqiu"
  else
    "/home/yuxqiu";
  news.display = "silent";
}
