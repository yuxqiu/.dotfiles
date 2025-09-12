{ pkgs, ... }:

{
  # GTK configuration
  # - dconf.service needs to be manually installed and enabled
  gtk = {
    enable = true; # Enables management of GTK configs

    # Theme and icons (applied to both GTK3 and GTK4)
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra; # Provides Adwaita icons/theme
    };
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    cursorTheme = {
      name = "Adwaita-dark";
      size = 24;
      package = pkgs.gnome-themes-extra;
    };

    # GTK3 extra settings (adds to ~/.config/gtk-3.0/settings.ini)
    gtk3.extraConfig = {
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = false;
      gtk-menu-images = false;
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = true;
    };

    # GTK4 extra settings (adds to ~/.config/gtk-4.0/settings.ini)
    gtk4.extraConfig = {
      gtk-enable-event-sounds = false;
      gtk-enable-input-feedback-sounds = false;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = true;
    };
  };

  # skip gsettings/dconf integration
  dconf.enable = false;

  home.sessionVariables = {
    # Force dark theme for GTK apps
    GTK_THEME = "Adwaita:dark";
  };
}
