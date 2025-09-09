{ pkgs, ... }:

let
  settings = builtins.readFile ./browser.toml;
in
{
  home.packages = with pkgs; [ captive-browser ];

  home.file.".config/captive-browser.toml".text = settings;
}
