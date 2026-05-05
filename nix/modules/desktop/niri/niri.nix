{
  flake.modules.homeManager.niri =
    { pkgs, lib, ... }:
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
      ];
      services.gnome-keyring.enable = true;

      wayland.windowManager.niri = {
        enable = true;
        package = pkgs.niri;
      };

      wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
        {
          match = {
            _props."app-id" = "gcr-prompter";
          };

          background-effect.blur = true;
          opacity = 0.6;
        }
      ];
    };

  flake.modules.systemManager.niri =
    { pkgs, ... }:
    {
      services.displayManager.sessionPackages = [ pkgs.niri ];
    };
}
