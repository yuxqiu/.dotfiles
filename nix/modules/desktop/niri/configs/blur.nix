{ lib, ... }:
{
  flake.modules.homeManager.linux-desktop = {
    wayland.windowManager.niri.settings = {
      blur = {
        passes = 3;
        offset = 3;
        noise = 0.02;
        saturation = 1.5;
      };

      window-rule = lib.mkAfter [
        {
          draw-border-with-background = false;
        }

        {
          match = {
            _props."is-floating" = true;
          };

          background-effect.xray = false;
        }
      ];

      layer-rule = [
        {
          match = [
            {
              _props.layer = "top";
            }
            {
              _props.layer = "overlay";
            }
          ];

          background-effect.xray = false;
        }
      ];
    };
  };
}
