{ pkgs, ... }: {
  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.gnome-keyring
    ];

    config.niri = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };

  services.gnome-keyring.enable = if builtins.pathExists /etc/NIXOS then false else true;

  home.file.".config/niri/configs".source = ./configs;
  home.file.".config/niri/config.kdl".source = ./config.kdl;
  home.file.".config/niri/dictation".source = ./dictation;
}
