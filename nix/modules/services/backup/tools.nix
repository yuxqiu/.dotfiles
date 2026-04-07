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
          pkgs.glibc.bin
          pkgs.restic
          rcloneWithConfig
        ];

        environment.systemPackages = config.backup.tools;
      };
    };
}
