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
          # for internal and external keyboard respectively
          options = "compose:menu,compose:ralt";
        };
      };

      mod-key = "Alt";
      mod-key-nested = "Super";
    };
  };
}
