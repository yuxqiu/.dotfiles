{
  inputs,
  ...
}:
{
  flake.modules.systemManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    # Modified from https://github.com/AvengeMedia/DankMaterialShell/blob/master/distro/nix/greeter.nix
    let
      cfg = config.programs.dank-material-shell.greeter;

      cacheDir = "/var/lib/dms-greeter";
      compositor = "niri";
      greetd-default-session-user = "greeter";

      configHome = cfg.configHome;
      configFiles = [
        "${configHome}/.config/DankMaterialShell/settings.json"
        "${configHome}/.local/state/DankMaterialShell/session.json"
        "${configHome}/.cache/DankMaterialShell/dms-colors.json"
      ];

      dms = inputs.dms.packages.${pkgs.stdenv.system};

      # greetd uses PATH to lookup niri and niri-session
      #
      # - Sidenote: dms-greeter -> quickshell (via niri) ->
      #   niri-session -> niri + niri.service (user)
      waylandSessionPackages = map (e: e.package) config.services.displayManager.waylandSessions.entries;
      greeterPath = lib.makeBinPath (
        [
          dms.quickshell
        ]
        ++ waylandSessionPackages
      );

      jq = lib.getExe pkgs.jq;
      dmsGreeterPreStart = pkgs.writeShellScriptBin "dms-greeter-prepare" ''
        mkdir -p ${cacheDir}
        cd ${cacheDir}

        ${lib.concatStringsSep "\n" (
          lib.map (f: ''
            if [ -f "${f}" ]; then
                cp "${f}" .
            fi
          '') configFiles
        )}

        if [ -f session.json ]; then
            copy_wallpaper() {
                local path=$(${jq} -r ".$1 // empty" session.json)
                if [ -f "$path" ]; then
                    cp "$path" "$2"
                    ${jq} ".$1 = \"${cacheDir}/$2\"" session.json > session.tmp
                    mv session.tmp session.json
                fi
            }

            copy_monitor_wallpapers() {
                ${jq} -r ".$1 // {} | to_entries[] | .key + \":\" + .value" session.json 2>/dev/null | while IFS=: read monitor path; do
                    local dest="$2-$(echo "$monitor" | tr -c '[:alnum:]' '-')"
                    if [ -f "$path" ]; then
                        cp "$path" "$dest"
                        ${jq} --arg m "$monitor" --arg p "${cacheDir}/$dest" ".$1[\$m] = \$p" session.json > session.tmp
                        mv session.tmp session.json
                    fi
                done
            }

            copy_wallpaper "wallpaperPath" "wallpaper"
            copy_wallpaper "wallpaperPathLight" "wallpaper-light"
            copy_wallpaper "wallpaperPathDark" "wallpaper-dark"
            copy_monitor_wallpapers "monitorWallpapers" "wallpaper-monitor"
            copy_monitor_wallpapers "monitorWallpapersLight" "wallpaper-monitor-light"
            copy_monitor_wallpapers "monitorWallpapersDark" "wallpaper-monitor-dark"
        fi

        if [ -f settings.json ]; then
            customTheme=$(${jq} -r '.customThemeFile' settings.json)
            if [ -n "$customTheme" ] && [ -f "$customTheme" ]; then
                cp -f "$customTheme" custom-theme.json
                mv settings.json settings.orig.json
                ${jq} '.customThemeFile = "${cacheDir}/custom-theme.json"' settings.orig.json > settings.json
            fi
        fi

        mv dms-colors.json colors.json || :
        chown ${greetd-default-session-user}: * || :
      '';

      dmsGreeterScript = pkgs.writeShellScriptBin "dms-greeter" ''
        export PATH=$PATH:${greeterPath}

        ${dms.dms-shell}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
        --cache-dir ${cacheDir} \
        --command ${compositor} -p ${dms.dms-shell}/share/quickshell/dms
      '';
    in
    {
      options.programs.dank-material-shell.greeter = {
        enable = lib.mkEnableOption "DankMaterialShell greeter";
        configHome = lib.mkOption {
          type = lib.types.str;
          example = "/home/username";
          description = ''
            Directory where dms-greeter configuration should be copied
            to the system-wide greeter at runtime.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.dms-greeter-prepare = {
          description = "Prepare DankMaterialShell greeter cache directory";
          before = [ "display-manager.service" ];
          wantedBy = [ "display-manager.service" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${dmsGreeterPreStart}/bin/dms-greeter-prepare";
          };

          # Only start if greeter is actually enabled & configHome exists
          unitConfig = {
            ConditionPathExists = cfg.configHome;
          };
        };

        environment.etc = {
          "greetd/config.toml" = {
            text = ''
              [terminal]
              # The VT to run the greeter on. Can be "next", "current" or a number
              # designating the VT.
              vt = 1

              # The default session, also known as the greeter.
              [default_session]

              command = "${dmsGreeterScript}/bin/dms-greeter"

              user = "${greetd-default-session-user}"
            '';
            mode = "0644";
          };
        };

        users.groups.${greetd-default-session-user} = { };
        users.users.${greetd-default-session-user} = {
          isSystemUser = true;
          group = "${greetd-default-session-user}";
          home = "/var/lib/${greetd-default-session-user}";
          createHome = true;
          description = "Greetd default session user";
        };
      };
    };
}
