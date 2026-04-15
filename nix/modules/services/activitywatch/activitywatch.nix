let
  aw-listening-address = {
    address = "127.0.0.1";
    port = 5600;
  };
in
{
  flake.modules.homeManager.linux-desktop =
    { pkgs, lib, ... }:
    {
      services.activitywatch = {
        enable = true;
        settings = { } // aw-listening-address;
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

      # watchers require env (like DISPLAY) that is related
      # to graphical session.
      systemd.user.targets.activitywatch = {
        Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
        Unit = {
          PartOf = lib.mkForce [ "graphical-session.target" ];
          After = lib.mkForce [ "graphical-session.target" ];
        };
      };

      programs.zed-editor = {
        extensions = [ "activitywatch" ];
        userSettings.lsp = {
          activitywatch = {
            settings = aw-listening-address;
          };
        };
      };

      programs.firefox.policies = {
        ExtensionSettings = {
          "{ef87d84c-2127-493f-b952-5b4e744245bc}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/{ef87d84c-2127-493f-b952-5b4e744245bc}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        "3rdparty".Extensions = {
          "{ef87d84c-2127-493f-b952-5b4e744245bc}" = {
            "consentOfflineDataCollection" = true;
          };
        };
      };
    };
}
