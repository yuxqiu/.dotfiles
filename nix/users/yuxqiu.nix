{ pkgs, ... }:
{
  home.stateVersion = "26.05";
  home.username = "yuxqiu";
  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/yuxqiu" else "/Users/yuxqiu";
}
