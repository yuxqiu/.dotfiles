{
  flake.modules.systemManager.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      autoresticBin = "${pkgs.autorestic}/bin/autorestic -c ${
        config.sops.secrets."autorestic.yaml".path
      }";
      resticBin = "${pkgs.restic}/bin/restic";
    in
    {
      config = lib.mkIf config.my.sops.enable {
        sops.secrets."autorestic.yaml" = {
          mode = "0400";
          owner = config.users.users.root.name;
          group = config.users.users.root.group;
        };

        # See:
        # - https://autorestic.vercel.app/
        # - https://gitlab.com/py_crash/autorestic-systemd-units
        systemd = {
          services = {
            autorestic-backup = {
              description = "Autorestic backup service";

              unitConfig = {
                ConditionPathExists = config.sops.secrets."autorestic.yaml".path;
              };

              serviceConfig = {
                Type = "oneshot";
                ExecStartPre = "${autoresticBin} --restic-bin ${resticBin} exec -av -- unlock";
                ExecStart = "${autoresticBin} --restic-bin ${resticBin} backup --verbose -l home";
                ExecStartPost = "${autoresticBin} --restic-bin ${resticBin} forget --verbose --all";
                WorkingDirectory = "%h";
              };
            };
            autorestic-prune = {
              unitConfig = {
                Description = "Autorestic backup service (data pruning)";
              };
              serviceConfig = {
                Type = "oneshot";
                ExecStartPre = "${autoresticBin} --restic-bin ${resticBin} exec -av -- unlock";
                ExecStart = "${autoresticBin} --restic-bin ${resticBin} forget --verbose --prune --all";
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

        environment.systemPackages = with pkgs; [
          autorestic
          restic
        ];
      };
    };
}
