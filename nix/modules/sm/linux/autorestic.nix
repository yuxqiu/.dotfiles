{ pkgs, ... }: {
  config = {
    # See:
    # - https://autorestic.vercel.app/
    # - https://gitlab.com/py_crash/autorestic-systemd-units
    systemd = {
      services = {
        autorestic-backup = {
          unitConfig = { Description = "Autorestic backup service"; };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.autorestic}/bin/autorestic --restic-bin ${pkgs.restic}/bin/restic backup --verbose -l home";
            ExecStartPost = "${pkgs.autorestic}/bin/autorestic --restic-bin ${pkgs.restic}/bin/restic forget --verbose --all";
            WorkingDirectory = "%h";
          };
        };
        autorestic-prune = {
          unitConfig = {
            Description = "Autorestic backup service (data pruning)";
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.autorestic}/bin/autorestic --restic-bin ${pkgs.restic}/bin/restic forget --verbose --prune --all";
            WorkingDirectory = "%h";
          };
        };
      };
      timers = {
        autorestic-backup = {
          enable = true;
          unitConfig = { Description = "Backup with autorestic daily"; };
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
}
