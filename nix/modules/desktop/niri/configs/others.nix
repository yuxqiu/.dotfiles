{
  flake.modules.homeManager.linux-desktop = {
    wayland.windowManager.niri.settings = {
      hotkey-overlay.skip-at-startup = [];

      environment.ELECTRON_OZONE_PLATFORM_HINT = "auto";

      screenshot-path = null;

      prefer-no-csd = [];
    };
  };
}
