{
  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.opensnitch-ui ];

      # Add restart as opensnitch-ui is started too early and crashes consistently.
      services.opensnitch-ui.enable = true;
      systemd.user.services.opensnitch-ui = {
        Service = {
          Restart = "on-failure";
          RestartSec = "5";
        };
      };
    };

  flake.modules.systemManager.gui =
    { pkgs, ... }:
    {
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
