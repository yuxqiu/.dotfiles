{ pkgs, ... }:
{
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;

    x11.enable = true;
    gtk.enable = true;
  };
}
