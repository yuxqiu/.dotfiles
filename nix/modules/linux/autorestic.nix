{ ... }: {
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
            ExecStart = "autorestic backup --verbose -l home";
            ExecStartPost = "autorestic forget --verbose --all";
            WorkingDirectory = "%h";
            Environment =
              "PATH=/usr/local/bin:/usr/bin"; # let autorestic find restic
          };
        };
        autorestic-prune = {
          unitConfig = {
            Description = "Autorestic backup service (data pruning)";
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "autorestic forget --verbose --prune --all";
            WorkingDirectory = "%h";
            Environment =
              "PATH=/usr/local/bin:/usr/bin"; # let autorestic find restic
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
  };
}
