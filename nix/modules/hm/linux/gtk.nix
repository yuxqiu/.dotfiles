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

    # GTK3 extra settings (adds to ~/.config/gtk-3.0/settings.ini)
    gtk3.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
    };

    # GTK4 extra settings (adds to ~/.config/gtk-4.0/settings.ini)
    gtk4.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
    };
  };

  # gsettings/dconf integration
  # - dconf is used by gtk module by default, so no need to conf it manually
  # dconf.enable = true;

  home.sessionVariables = {
    # Force dark theme for GTK apps
    GTK_THEME = "Adwaita:dark";
  };
}
