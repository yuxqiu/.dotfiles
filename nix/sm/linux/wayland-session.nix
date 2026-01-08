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
              description = "The display name of the compositor.";
            };
            sessionName = lib.mkOption {
              type = lib.types.str;
              example = "niri-session";
              description = ''
                The session binary of the compositor (used for Exec).
              '';
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = null;
              example = "pkgs.niri";
              description = "The package providing the compositor. If set, the session binary will be searched in $out/bin of this package using the base name from sessionName.";
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
      {
        assertion = builtins.all (e: e.sessionName != "") cfg.entries;
        message = "Each waylandSessions entry must have a non-empty sessionName.";
      }
    ];

    environment.systemPackages = map (e: e.package) cfg.entries;

    systemd.tmpfiles.rules = map (
      entry:
      let
        compName = entry.compositorName;
        sessName = lib.toLower compName;
        execCmd = "${entry.package}/bin/${baseNameOf entry.sessionName}";
        desktopFile = pkgs.writeText "${sessName}.desktop" ''
          [Desktop Entry]
          Name=${compName}
          Exec=${execCmd}
          Type=Application
          DesktopNames=${compName}
          ${entry.extraDesktopEntries}
        '';
      in
      "L+ /usr/share/wayland-sessions/${sessName}.desktop - - - - ${desktopFile}"
    ) cfg.entries;
  };
}
