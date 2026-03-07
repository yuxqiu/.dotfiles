{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    { pkgs, lib, ... }:
    {
      imports = [ inputs.niri-nix.homeModules.default ];

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
        package = inputs.niri.packages.${pkgs.stdenv.system}.default;
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

  flake.modules.systemManager.desktop =
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
