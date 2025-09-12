{ pkgs, ... }:

{
  home.packages = with pkgs; [ captive-browser ];
  home.file.".config/captive-browser.toml".source = ./captive-browser.toml;
}
