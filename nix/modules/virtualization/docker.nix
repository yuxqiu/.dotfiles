{
  flake.modules.systemManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      # Create docker group and add the user to it
      users.groups.docker = { };
      users.users.${config.user.username} = {
        extraGroups = [ "docker" ];
      };

      # https://discourse.nixos.org/t/how-to-run-docker-daemon-from-nix-not-nixos/43413
      environment = {
        systemPackages = with pkgs; [
          docker
        ];
      };

      systemd.services = {
        docker = {
          enable = true;
          description = "Docker Application Container Engine";
          documentation = [ "https://docs.docker.com" ];
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            Type = "notify";
            Environment = [
              "PATH=${
                lib.makeBinPath [
                  pkgs.docker
                  pkgs.coreutils
                  pkgs.kmod
                ]
              }:/usr/bin:/sbin"
            ];
            ExecStart = "${pkgs.docker}/bin/dockerd";
            ExecStartPost = [
              "${pkgs.coreutils}/bin/chmod 666 /var/run/docker.sock"
              "${pkgs.coreutils}/bin/chown root:docker /var/run/docker.sock"
            ];
            ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
            TimeoutStartSec = 0;
            RestartSec = 2;
            Restart = "always";
            StartLimitBurst = 3;
            StartLimitInterval = "60s";
            LimitNOFILE = "infinity";
            LimitNPROC = "infinity";
            LimitCORE = "infinity";
            TasksMax = "infinity";
            Delegate = true;
            KillMode = "process";
            OOMScoreAdjust = -500;
          };
        };
      };
    };
}
