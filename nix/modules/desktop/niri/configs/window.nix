{ lib, ... }:
{
  flake.modules.homeManager.linux-desktop = {
    wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
      {
        geometry-corner-radius = 12;
        clip-to-geometry = true;
      }

      {
        match = {
          _props."is-window-cast-target" = true;
        };

        focus-ring = {
          active-color = "#f38ba8";
          inactive-color = "#7d0d2d";
        };

        tab-indicator = {
          active-color = "#f38ba8";
          inactive-color = "#7d0d2d";
        };
      }
    ];
  };
}
