{
  flake.modules.systemManager.udev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.udev;

      rulesTmpfiles =
        pkgs.runCommand "udev-rules-tmpfiles"
          {
            packages = lib.unique (map toString cfg.packages);
          }
          ''
            set -euo pipefail

            seen="$TMPDIR/udev-rules-seen"
            : > "$seen"
            mkdir -p "$out"
            rules="$out/rules"
            manifest="$out/manifest"
            : > "$manifest"

            {
              echo "d /etc/udev/rules.d 0755 root root - -"

              for pkg in $packages; do
                for dir in "$pkg/etc/udev/rules.d" "$pkg/lib/udev/rules.d"; do
                  [ -d "$dir" ] || continue
                  while IFS= read -r -d "" f; do
                    base="$(basename "$f")"
                    if grep -qxF "$base" "$seen"; then
                      echo "Duplicate udev rule filename: $base" >&2
                      exit 1
                    fi
                    echo "$base" >> "$seen"
                    echo "L /etc/udev/rules.d/$base - - - - $f"
                    echo "$f" >> "$manifest"
                  done < <(find -L "$dir" -type f -print0)
                done
              done
            } > "$rules"
          '';
      udevCleanup = pkgs.writeShellScript "udev-tmpfiles-cleanup" ''
        set -euo pipefail

        manifest="${rulesTmpfiles}/manifest"
        if [ ! -f "$manifest" ]; then
          exit 0
        fi

        if [ -d /etc/udev/rules.d ]; then
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
          done < <(find /etc/udev/rules.d -type l -print0)
        fi
      '';
    in
    {
      options.services.udev = {
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          example = lib.literalExpression "[ pkgs.libinput pkgs.usbutils ]";
          description = ''
            Packages that ship udev rules in `etc/udev/rules.d` or
            `lib/udev/rules.d`. The rules are symlinked into `/etc/udev/rules.d`.
          '';
        };
        extraRules = lib.mkOption {
          type = lib.types.lines;
          default = "";
          example = ''
            ENV{ID_VENDOR_ID}=="046d", ENV{ID_MODEL_ID}=="0825", ENV{PULSE_IGNORE}="1"
          '';
          description = ''
            Additional udev rules written to `/etc/udev/rules.d/99-local.rules`.
          '';
        };
      };

      config = lib.mkMerge [
        {
          systemd.tmpfiles.rules = lib.filter (line: line != "") (
            lib.splitString "\n" (builtins.readFile "${rulesTmpfiles}/rules")
          );
        }
        (lib.mkIf (cfg.extraRules != "") {
          environment.etc."udev/rules.d/99-local.rules" = {
            text = cfg.extraRules;
            mode = "0644";
            replaceExisting = true;
          };
        })
        (lib.mkIf (cfg.packages != [ ] || cfg.extraRules != "") {
          systemd.services.udev-reload = {
            description = "Reload udev rules when rules change";
            serviceConfig = {
              Type = "oneshot";
              ExecStartPre = "${udevCleanup}";
              ExecStart = "${pkgs.systemd}/bin/udevadm control --reload-rules";
              ExecStartPost = "${pkgs.systemd}/bin/udevadm trigger --type=devices --action=change";
            };
          };

          systemd.paths.udev-reload = {
            wantedBy = [ "system-manager.target" ];
            pathConfig = {
              Unit = "udev-reload.service";
              PathChanged = [ "/etc/udev/rules.d" ];
              PathModified = [ "/etc/udev/rules.d/*.rules" ];
            };
          };
        })
      ];
    };
}
