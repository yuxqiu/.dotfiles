{ inputs, ... }:
{
  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      xdg.portal = {
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

      home.packages = [
        pkgs.xwayland-satellite
        # for gnome-keyring prompt to show
        # - https://github.com/nix-community/home-manager/issues/1454
        pkgs.gcr
        inputs.niri.packages.${pkgs.stdenv.system}.default
      ];
      services.gnome-keyring.enable = true;

      home.file.".config/niri/configs".source = ./configs;
      home.file.".config/niri/config.kdl".source = ./config.kdl;
    };

  flake.modules.systemManager.gui =
    { pkgs, ... }:
    {
      services.displayManager.waylandSessions = {
        enable = true;

        entries = [
          {
            compositorName = "Niri";
            sessionName = "niri-session";
            package = inputs.niri.packages.${pkgs.stdenv.system}.default;
          }
        ];
      };
    };
}
