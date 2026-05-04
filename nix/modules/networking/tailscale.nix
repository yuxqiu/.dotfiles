{
  flake.modules.homeManager.tailscale =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ tailscale ];
    };

  flake.modules.systemManager.tailscale =
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

        services.tailscale.serve.endpoints = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          example = lib.literalExpression ''
            {
              "https:4433" = "http://127.0.0.1:4433";
              "tcp:6767" = "tcp://127.0.0.1:6767";
            }
          '';
          description = ''
            Mapping of tailscale serve listeners to backend targets.
            The key is the listen specifier (proto:port), the value is the target URL.
            Examples: "https:4433", "tcp:6767", "http:8080"
          '';
        };
      };

      config = lib.mkIf config.my.sops.enable {
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
          let
            endpoints = config.services.tailscale.serve.endpoints;

            tailscaleServeScript = pkgs.writeShellApplication {
              name = "tailscale-serve";
              runtimeInputs = [
                pkgs.tailscale
                pkgs.jq
              ];
              text =
                let
                  serveLines =
                    lib.concatMapStringsSep "\n"
                      (entry: "tailscale serve --bg --${entry.proto} ${entry.port} ${entry.target}")
                      (
                        lib.mapAttrsToList (
                          listener: target:
                          let
                            parts = lib.splitString ":" listener;
                          in
                          {
                            proto = lib.head parts;
                            port = lib.last parts;
                            inherit target;
                          }
                        ) endpoints
                      );
                in
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
          in
          lib.mkIf (config.services.tailscale.enable && endpoints != { }) {
            description = "Tailscale serve proxy service";
            wantedBy = [ "multi-user.target" ];
            after = [ "tailscaled.service" ];
            wants = [ "tailscaled.service" ];
            partOf = [ "tailscaled.service" ];
            enableStrictShellChecks = true;
            serviceConfig = {
              RemainAfterExit = true;
              Restart = "on-failure";
              RestartSec = "2s";
              ExecStop = "${lib.getExe pkgs.tailscale} serve reset";
            };
            script = "${tailscaleServeScript}/bin/tailscale-serve";
          };
      };
    };
}
