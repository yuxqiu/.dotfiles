{ pkgs, ... }:
{
  config = {
    environment.etc = {
      "opensnitchd/default-config.json".source = ./res/default-config.json;
      "opensnitchd/system-fw.json".source = ./res/system-fw.json;
    };

    systemd.services.opensnitchd = {
      description = "Application firewall OpenSnitch";
      documentation = [ "https://github.com/evilsocket/opensnitch/wiki" ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        PermissionsStartOnly = true;
        ExecStartPre = "/bin/mkdir -p /etc/opensnitchd/rules";
        ExecStart = "${pkgs.opensnitch}/bin/opensnitchd -rules-path /etc/opensnitchd/rules";
        Restart = "always";
        RestartSec = 30;
        TimeoutStopSec = 10;
      };
    };
  };
}
