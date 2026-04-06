{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ tailscale ];
    };

  flake.modules.systemManager.desktop =
    {
      nixosModulesPath,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ (nixosModulesPath + "/services/networking/tailscale.nix") ];

      options = {
        networking.dhcpcd = lib.mkOption {
          type = lib.types.raw;
        };

        networking.useNetworkd = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        networking.resolvconf.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        systemd.network = lib.mkOption {
          type = lib.types.raw;
        };
        networking.networkmanager.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        services.tailscale.serveHttpsTargets = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = ''
            Mapping of ports to backend targets for tailscale serve.
            Example: { "3000" = "http://localhost:3000"; "8080" = "http://localhost:8080"; }
          '';
        };
      };

      config = {
        sops.secrets."tailscale_key" = {
          mode = "0400";
          owner = config.users.users.root.name;
          restartUnits = [ "tailscaled.service" ];
        };

        services.tailscale = {
          authKeyFile = config.sops.secrets."tailscale_key".path;
          disableUpstreamLogging = true;
          extraUpFlags = [ "--ssh" ];
          extraDaemonFlags = [ "--no-logs-no-support" ];
        };

        systemd.services.tailscale-serve =
          lib.mkIf (config.services.tailscale.enable && config.services.tailscale.serveHttpsTargets != { })
            {
              description = "Tailscale serve proxy service";
              wantedBy = [ "multi-user.target" ];
              after = [ "tailscaled.service" ];
              wants = [ "tailscaled.service" ];
              partOf = [ "tailscaled.service" ];
              path = [
                pkgs.tailscale
                pkgs.jq
              ];
              enableStrictShellChecks = true;
              serviceConfig = {
                RemainAfterExit = true;
                Restart = "on-failure";
                RestartSec = "2s";
                ExecStop = "${lib.getExe pkgs.tailscale} serve reset";
              };
              script =
                let
                  serveLines =
                    lib.concatMapStringsSep "\n" (entry: "tailscale serve --bg --https ${entry.port} ${entry.target}")
                      (
                        lib.mapAttrsToList (port: target: {
                          inherit port target;
                        }) config.services.tailscale.serveHttpsTargets
                      );
                in
                # bash
                ''
                  getState() {
                    tailscale status --json --peers=false | jq -r '.BackendState'
                  }

                  lastState=""
                  while state="$(getState)"; do
                    if [[ "$state" != "$lastState" ]]; then
                      case "$state" in
                        Running)
                          echo "Tailscale is running, configuring serve"
                          ${serveLines}
                          exit 0
                          ;;
                        NeedsLogin|NeedsMachineAuth|Stopped)
                          echo "Tailscale not ready, waiting for state = Running"
                          ;;
                        *)
                          echo "Waiting for Tailscale State = Running or systemd timeout"
                          ;;
                      esac
                      echo "State = $state"
                    fi
                    lastState="$state"
                    sleep .5
                  done
                '';
            };
      };
    };
}
