{
  flake.modules.systemManager.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      autoresticWithConfig = pkgs.symlinkJoin {
        name = "autorestic";
        paths = [ pkgs.autorestic ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/autorestic" \
            --add-flags "--config ${config.sops.secrets."autorestic.yaml".path}"
        '';
      };
      rcloneWithConfig = pkgs.symlinkJoin {
        name = "rclone";
        paths = [ pkgs.rclone ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/rclone" \
            --add-flags "--config ${config.sops.secrets."rclone.conf".path}"
        '';
      };
      autoresticInit = pkgs.writeShellApplication {
        name = "autorestic-init";
        runtimeInputs = [
          autoresticWithConfig
        ];
        text = ''
          set -euo pipefail

          usage() {
            echo "Usage: autorestic-init" >&2
            exit 1
          }

          autorestic_config="${config.sops.secrets."autorestic.yaml".path}"
          rclone_config="${config.sops.secrets."rclone.conf".path}"

          if [ ! -f "$autorestic_config" ]; then
            echo "Missing autorestic config: $autorestic_config" >&2
            exit 1
          fi
          if [ ! -f "$rclone_config" ]; then
            echo "Missing rclone config: $rclone_config" >&2
            exit 1
          fi

          export RCLONE_CONFIG="$rclone_config"
          autorestic_bin="$(command -v autorestic)"
          if [ -z "$autorestic_bin" ]; then
            echo "autorestic not found in PATH" >&2
            exit 1
          fi
          sudo --preserve-env=RCLONE_CONFIG \
            env PATH="$PATH" \
            "$autorestic_bin" check
        '';
      };
    in
    {
      options = {
        backup.tools = lib.mkOption {
          type = lib.types.listOf lib.types.package;
        };
      };

      config = lib.mkIf config.my.sops.enable {
        sops.secrets."rclone.conf" = {
          mode = "0400";
          owner = config.users.users.root.name;
          group = config.users.users.root.group;
        };

        backup.tools = [
          autoresticWithConfig
          autoresticInit
          pkgs.glibc.bin
          pkgs.restic
          rcloneWithConfig
        ];

        environment.systemPackages = config.backup.tools;
      };
    };
}
