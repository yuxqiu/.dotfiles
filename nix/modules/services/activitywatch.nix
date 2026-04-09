{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      services.activitywatch = {
        enable = true;
        settings = {
          address = "127.0.0.1";
          port = 5600;
        };
        watchers = {
          aw-watcher-afk = {
            package = pkgs.activitywatch;
            settings = {
              timeout = 300;
              poll_time = 2;
            };
          };

          aw-watcher-window-wayland = {
            package = pkgs.aw-watcher-window-wayland;
            settings = {
              poll_time = 1;
              exclude_title = true;
            };
          };
        };
      };
    };

  flake.modules.systemManager.desktop = {
    services.tailscale.serveHttpsTargets = {
      "5600" = "http://127.0.0.1:5600";
    };
  };
}
