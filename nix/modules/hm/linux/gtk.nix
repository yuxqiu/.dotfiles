{ pkgs, ... }:

{
  gtk = {
    enable = true; # Enables management of GTK configs

    # Theme and icons (applied to both gtk2/gtk3, gtk4 does not support theming)
    # https://github.com/nix-community/home-manager/commit/ae9f38e88963fcd68b3c07885beb5cf36f1e17c8
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    colorScheme = "dark";
  };
}
