{ pkgs, ... }:

{
  gtk = {
    enable = true; # Enables management of GTK configs

    # Theme and icons (applied to both GTK3 and GTK4)
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra; # Provides Adwaita icons/theme
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;
    };
    colorScheme = "dark";

    # GTK3 extra settings (adds to ~/.config/gtk-3.0/settings.ini)
    gtk3.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-application-prefer-dark-theme = true;
    };

    # GTK4 extra settings (adds to ~/.config/gtk-4.0/settings.ini)
    gtk4.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-application-prefer-dark-theme = true;
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
