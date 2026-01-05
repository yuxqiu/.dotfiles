{ pkgs, ... }:
let
  autoresticBin = "${pkgs.autorestic}/bin/autorestic";
  resticBin = "${pkgs.restic}/bin/restic";
in
{
  config = {
    # See:
    # - https://autorestic.vercel.app/
    # - https://gitlab.com/py_crash/autorestic-systemd-units
    systemd = {
      services = {
        autorestic-backup = {
          unitConfig = {
            Description = "Autorestic backup service";
          };
          serviceConfig = {
            Type = "oneshot";
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
}
