{

  flake.modules.nixos.tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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
    {
      options.services.tailscale.serve.endpoints = lib.mkOption {
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
        '';
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

        systemd.services.tailscale-serve = lib.mkIf (config.services.tailscale.enable && endpoints != { }) {
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
