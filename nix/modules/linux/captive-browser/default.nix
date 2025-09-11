{ pkgs, ... }:

let
  settings = builtins.readFile ./captive-browser.toml;
in
{
  home.packages = with pkgs; [ captive-browser ];

  home.file.".config/captive-browser.toml".text = settings;
}
