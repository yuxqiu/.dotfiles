{
  flake.modules.systemManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.displayManager.waylandSessions;
      mkEntry =
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
        {
          target = "/usr/share/wayland-sessions/${sessName}.desktop";
          source = desktopFile;
        };
      entries = map mkEntry cfg.entries;
      waylandSessionsManifest = pkgs.writeText "wayland-sessions-manifest" (
        lib.concatStringsSep "\n" (map (e: e.source) entries)
      );
      waylandSessionsCleanup = pkgs.writeShellScript "wayland-sessions-tmpfiles-cleanup" ''
        set -euo pipefail

        manifest="${waylandSessionsManifest}"
        if [ ! -f "$manifest" ]; then
          exit 0
        fi

        if [ -d /usr/share/wayland-sessions ]; then
          while IFS= read -r -d "" link; do
            target="$(readlink "$link" || true)"
            [ -n "$target" ] || continue
            case "$target" in
              /nix/store/*)
                if [ ! -e "$target" ] || ! grep -qxF "$target" "$manifest"; then
                  rm -f "$link"
                fi
                ;;
              *)
                ;;
            esac
          done < <(find /usr/share/wayland-sessions -type l -print0)
        fi
      '';
    in
    {
      # Once environment.sessionVariables is supported by system-manager, we can
      # import /services/display-managers/default.nix from nixos to manage
      # the following properly and simplify niri wayland-session config.
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

        systemd.tmpfiles.rules = map (entry: "L+ ${entry.target} - - - - ${entry.source}") entries;

        systemd.services.wayland-sessions-tmpfiles-cleanup = {
          description = "Clean stale wayland session tmpfiles symlinks";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${waylandSessionsCleanup}";
          };
        };

        systemd.paths.wayland-sessions-tmpfiles-cleanup = {
          wantedBy = [ "system-manager.target" ];
          pathConfig = {
            Unit = "wayland-sessions-tmpfiles-cleanup.service";
            PathChanged = [ "/usr/share/wayland-sessions" ];
            PathModified = [ "/usr/share/wayland-sessions/*.desktop" ];
          };
        };
      };
    };
}
