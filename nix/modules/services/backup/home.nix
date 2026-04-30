{
  flake.modules.systemManager.base =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkIf config.my.sops.enable {
        sops.secrets."autorestic.yaml" = {
          mode = "0400";
          owner = config.users.users.root.name;
          inherit (config.users.users.root) group;
        };

        # See:
        # - https://autorestic.vercel.app/
        # - https://gitlab.com/py_crash/autorestic-systemd-units
        systemd = {
          services = {
            autorestic-backup = {
              description = "Autorestic backup service";

              path = config.backup.tools;

              unitConfig = {
                ConditionPathExists = config.sops.secrets."autorestic.yaml".path;
              };

              serviceConfig = {
                Type = "oneshot";
                ExecSearchPath = lib.makeBinPath config.backup.tools;
                Environment = "RCLONE_CONFIG=${config.sops.secrets."rclone.conf".path}";
                ExecStartPre = "autorestic exec -av -- unlock";
                ExecStart = "autorestic backup --verbose -l home";
                ExecStartPost = "autorestic forget --verbose --all";
                WorkingDirectory = "%h";
              };
            };
            autorestic-prune = {
              path = config.backup.tools;

              unitConfig = {
                Description = "Autorestic backup service (data pruning)";
              };
              serviceConfig = {
                Type = "oneshot";
                ExecSearchPath = lib.makeBinPath config.backup.tools;
                Environment = "RCLONE_CONFIG=${config.sops.secrets."rclone.conf".path}";
                ExecStartPre = "autorestic exec -av -- unlock";
                ExecStart = "autorestic forget --verbose --prune --all";
                WorkingDirectory = "%h";
              };
            };
          };

          timers = {
            autorestic-backup = {
              enable = true;
              unitConfig = {
                Description = "Backup with autorestic daily";
              };
              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = "daily";
                Persistent = true;
              };
            };
            autorestic-prune = {
              enable = true;
              unitConfig = {
                Description = "Prune data from the restic repository monthly";
              };
              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = "monthly";
                Persistent = true;
              };
            };
          };
        };
      };
    };
}
