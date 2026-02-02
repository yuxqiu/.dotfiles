{
  inputs,
  ...
}:
{
  flake.modules.systemManager.gui =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    # Modified from https://github.com/AvengeMedia/DankMaterialShell/blob/master/distro/nix/greeter.nix
    let
      cfg = config.programs.dank-material-shell.greeter;

      user = cfg.user;
      cacheDir = "/tmp/dms-greeter";
      compositor = "niri";

      configHome = config.users.users.${user}.home;
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

      prelude = "export PATH=$PATH:${greeterPath}";

      jq = lib.getExe pkgs.jq;
      prestart = ''
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
            if cp "$(${jq} -r '.customThemeFile' settings.json)" custom-theme.json; then
                mv settings.json settings.orig.json
                ${jq} '.customThemeFile = "${cacheDir}/custom-theme.json"' settings.orig.json > settings.json
            fi
        fi

        mv dms-colors.json colors.json || :

        chown -R greeter:greeter ${cacheDir} || true
      '';

      greeterScript = ''
        ${dms.dms-shell}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
        --cache-dir ${cacheDir} \
        --command ${compositor} -p ${dms.dms-shell}/share/quickshell/dms
      '';

      script = pkgs.writeShellScriptBin "dms-greeter" (
        lib.concatStringsSep "\n" [
          prelude
          prestart
          greeterScript
        ]
      );
    in
    {
      options.programs.dank-material-shell.greeter = {
        enable = lib.mkEnableOption "DankMaterialShell greeter";
        user = lib.mkOption {
          type = lib.types.str;
          example = "username";
          description = ''
            User account whose greeter configuration (lightdm-gtk-greeter settings, theme,
            background, font, etc.) should be copied to the system-wide greeter at runtime.

            greetd will then start dms-greeter in this user.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        environment.etc = {
          # Required to run greeter in current user to copy settings files
          # from user dirs to cache dirs.
          # - Security Implications: acceptable for a single-user machine.
          "greetd/config.toml" = {
            text = ''
              [terminal]
              # The VT to run the greeter on. Can be "next", "current" or a number
              # designating the VT.
              vt = 1

              # The default session, also known as the greeter.
              [default_session]

              command = "${script}/bin/dms-greeter"

              user = "${user}"
            '';
            mode = "0644";
          };
        };
      };
    };
}
