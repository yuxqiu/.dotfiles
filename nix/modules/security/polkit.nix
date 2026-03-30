{
  flake.modules.systemManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.security.polkit.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      config =
        let
          polkitTmpfiles = pkgs.runCommand "polkit-1-tmpfiles" { } ''
            set -euo pipefail

            {
              echo "d /usr/share/polkit-1 0755 root root - -"

              if [ -d "${config.system.path}/share/polkit-1" ]; then
                while IFS= read -r -d "" f; do
                  dest="/usr/share/''${f#"${config.system.path}/share/"}"
                  echo "L $dest - - - - $f"
                done < <(find -L "${config.system.path}/share/polkit-1" -type f -print0)
              fi
            } > "$out"
          '';
        in
        {
          # The polkit daemon reads action/rule files
          environment.pathsToLink = [ "/share/polkit-1" ];

          systemd.tmpfiles.rules = lib.filter (line: line != "") (
            lib.splitString "\n" (builtins.readFile polkitTmpfiles)
          );

          systemd.services.polkit-reload = {
            description = "Reload polkit when rules change";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.systemd}/bin/systemctl try-reload-or-restart polkit.service";
            };
          };

          systemd.paths.polkit-reload = {
            wantedBy = [ "paths.target" ];
            pathConfig = {
              Unit = "polkit-reload.service";
              PathChanged = [
                "/usr/share/polkit-1"
                "/etc/polkit-1"
              ];
              PathModified = [
                "/usr/share/polkit-1/actions/*.policy"
                "/usr/share/polkit-1/rules.d/*.rules"
                "/etc/polkit-1/rules.d/*.rules"
              ];
            };
          };

          # TODO: once polkit-agent-helper-1 is removed in host system and switch to socket-activated
          # `polkit-agent-helper`, this can be removed.
          security.wrappers = {
            polkit-agent-helper-1 = {
              setuid = true;
              owner = "root";
              group = "root";
              source = "${pkgs.polkit.out}/lib/polkit-1/polkit-agent-helper-1";
            };
          };
        };
    };
}
