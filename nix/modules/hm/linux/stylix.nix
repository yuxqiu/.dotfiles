{ pkgs, ... }:
{
  stylix = {
    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      light = "Adwaita";
      dark = "Adwaita";
    };
  };
}
