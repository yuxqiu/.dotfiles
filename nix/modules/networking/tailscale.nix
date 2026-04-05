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
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart =
                  let
                    serveScript = pkgs.writeShellApplication {
                      name = "tailscale-serve-init";
                      text = ''
                        ${lib.concatMapStringsSep "\n"
                          (entry: "${lib.getExe pkgs.tailscale} serve --bg --https ${entry.port} ${entry.target}")
                          (
                            lib.mapAttrsToList (port: target: {
                              inherit port target;
                            }) config.services.tailscale.serveHttpsTargets
                          )
                        }
                      '';
                    };
                  in
                  "${lib.getExe serveScript}";
                ExecStop = "${lib.getExe pkgs.tailscale} serve reset";
              };
            };
      };
    };
}
