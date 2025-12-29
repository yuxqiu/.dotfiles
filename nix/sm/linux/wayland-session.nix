{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager.waylandSessions;
in
{
  options.services.displayManager.waylandSessions = {
    enable = lib.mkEnableOption "custom Wayland session .desktop file generation";

    entries = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            compositorName = lib.mkOption {
              type = lib.types.str;
              example = "Niri";
              description = "The display name of the compositor (used for Name, Comment, Exec, and DesktopNames).";
            };

            sessionName = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "niri";
              description = ''
                The session identifier (filename of the .desktop file, e.g., "niri.desktop").
                Defaults to lowercase of compositorName if not specified.
              '';
            };

            extraDesktopEntries = lib.mkOption {
              type = lib.types.lines;
              default = "";
              example = "Keywords=wayland;tiling;";
              description = "Additional lines to append to the [Desktop Entry] section.";
            };
          };
        }
      );
      default = [ ];
      description = "List of custom Wayland compositors to generate session files for.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.all (e: e.compositorName != "") cfg.entries;
        message = "Each waylandSessions entry must have a non-empty compositorName.";
      }
    ];

    systemd.tmpfiles.rules = map (
      entry:
      let
        compName = entry.compositorName;
        sessName = if entry.sessionName != null then entry.sessionName else lib.toLower compName;

        desktopFile = pkgs.writeText "${sessName}.desktop" ''
          [Desktop Entry]
          Name=${compName}
          Exec=${lib.toLower compName}-session
          Type=Application
          DesktopNames=${compName}
          ${entry.extraDesktopEntries}
        '';
      in
      "L+ /usr/share/wayland-sessions/${sessName}.desktop - - - - ${desktopFile}"
    ) cfg.entries;
  };
}
