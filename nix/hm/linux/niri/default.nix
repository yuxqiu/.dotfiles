{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.gnome-keyring
    ];

    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };

  # for gnome-keyring prompt to show
  # - https://github.com/nix-community/home-manager/issues/1454
  home.packages = [ pkgs.gcr ];
  services.gnome-keyring.enable = true;

  home.file.".config/niri/configs".source = ./configs;
  home.file.".config/niri/config.kdl".source = ./config.kdl;

  imports = [ ./scripts/dictation.nix ];
}
