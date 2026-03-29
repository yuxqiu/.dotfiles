{
  flake.modules.systemManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.dbus;
      allowedSubpaths = [
        "etc/dbus-1/system.d"
        "etc/dbus-1/session.d"
        "share/dbus-1/system.d"
        "share/dbus-1/system-services"
        "share/dbus-1/session.d"
        "share/dbus-1/services"
        "share/dbus-1/interfaces"
        "share/dbus-1/accessibility-services"
      ];
      packagesArg = lib.escapeShellArgs (map (pkg: "${pkg}") cfg.packages);
      dbusTmpfiles = pkgs.runCommand "dbus-1-tmpfiles" { } ''
        set -euo pipefail

        packages=(${packagesArg})

        {
          echo "d /etc/dbus-1 0755 root root - -"
          echo "d /etc/dbus-1/system.d 0755 root root - -"
          echo "d /etc/dbus-1/session.d 0755 root root - -"
          echo "d /usr/share/dbus-1 0755 root root - -"
          echo "d /usr/share/dbus-1/system.d 0755 root root - -"
          echo "d /usr/share/dbus-1/system-services 0755 root root - -"
          echo "d /usr/share/dbus-1/session.d 0755 root root - -"
          echo "d /usr/share/dbus-1/services 0755 root root - -"
          echo "d /usr/share/dbus-1/interfaces 0755 root root - -"
          echo "d /usr/share/dbus-1/accessibility-services 0755 root root - -"

          for pkg in "''${packages[@]}"; do
            for rel in ${lib.concatStringsSep " " allowedSubpaths}; do
              if [ -d "$pkg/$rel" ]; then
                while IFS= read -r -d "" f; do
                  case "$rel" in
                    etc/dbus-1/*)
                      dest="/etc/''${f#"$pkg/etc/"}"
                      ;;
                    share/dbus-1/*)
                      dest="/usr/share/''${f#"$pkg/share/"}"
                      ;;
                    *)
                      continue
                      ;;
                  esac
                  echo "L $dest - - - - $f"
                done < <(find -L "$pkg/$rel" -type f -print0)
              fi
            done
          done
        } > "$out"
      '';
    in
    {
      options.services.dbus.packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Packages whose D-Bus configuration files should be linked into the
          system-wide D-Bus locations.

          Specifically, files from the following directories are exposed:
          - «pkg»/etc/dbus-1/system.d
          - «pkg»/etc/dbus-1/session.d
          - «pkg»/share/dbus-1/system.d
          - «pkg»/share/dbus-1/system-services
          - «pkg»/share/dbus-1/session.d
          - «pkg»/share/dbus-1/services
          - «pkg»/share/dbus-1/interfaces
          - «pkg»/share/dbus-1/accessibility-services
        '';
      };

      config = lib.mkIf (cfg.packages != [ ]) {
        systemd.tmpfiles.rules = lib.filter (line: line != "") (
          lib.splitString "\n" (builtins.readFile dbusTmpfiles)
        );

        systemd.services.dbus-reload = {
          description = "Reload D-Bus when rules change";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.systemd}/bin/systemctl reload dbus";
          };
        };

        systemd.paths.dbus-reload = {
          wantedBy = [ "system-manager.target" ];
          pathConfig = {
            Unit = "dbus-reload.service";
            PathChanged = [
              "/etc/dbus-1"
              "/etc/dbus-1/system.d"
              "/etc/dbus-1/session.d"
              "/usr/share/dbus-1"
              "/usr/share/dbus-1/system.d"
              "/usr/share/dbus-1/system-services"
              "/usr/share/dbus-1/session.d"
              "/usr/share/dbus-1/services"
            ];
            PathModified = [
              "/etc/dbus-1/system.d/*.conf"
              "/etc/dbus-1/session.d/*.conf"
              "/usr/share/dbus-1/system.d/*.conf"
              "/usr/share/dbus-1/session.d/*.conf"
              "/usr/share/dbus-1/services/*.service"
              "/usr/share/dbus-1/system-services/*.service"
            ];
          };
        };
      };
    };
}
