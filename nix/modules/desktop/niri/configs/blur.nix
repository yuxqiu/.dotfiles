{ lib, ... }:
{
  flake.modules.homeManager.niri = {
    wayland.windowManager.niri.settings = {
      blur = {
        passes = 3;
        offset = 3;
        noise = 0.02;
        saturation = 1.5;
      };

      _children = lib.mkAfter [
        {
          window-rule.draw-border-with-background = false;
        }

        {
          window-rule = {
            match._props."is-floating" = true;
            background-effect.xray = false;
          };
        }

        {
          layer-rule._children = [
            { match._props.layer = "top"; }
            { match._props.layer = "overlay"; }
            { background-effect.xray = false; }
          ];
        }
      ];
    };
  };
}
