{ pkgs, ... }: {
  home.stateVersion = "25.11";
  home.username = "yuxqiu";
  home.homeDirectory =
    if pkgs.stdenv.isLinux then "/home/yuxqiu" else "/Users/yuxqiu";
  news.display = "silent";
}
