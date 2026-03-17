{
  flake.modules.homeManager.linux-desktop = {
    wayland.windowManager.niri.settings.input = {
      workspace-auto-back-and-forth = [ ];

      touchpad = {
        tap = [ ];
        dwt = [ ];
        natural-scroll = [ ];
        middle-emulation = [ ];
        accel-speed = 0.2;
      };

      mouse.accel-speed = 0.2;

      keyboard = {
        xkb = {
          options = "compose:ralt";
        };
      };

      mod-key = "Alt";
      mod-key-nested = "Super";
    };
  };
}
