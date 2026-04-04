{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.networking = {
      tailscale = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Tailscale for secure networking";
      };

      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address to bind/listen on for networking. Defaults to loopback, but should be set to your Tailscale IP when tailscale is enabled.";
      };

      publicHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Public hostname for external access (e.g., hostname.ts.net). Defaults to bindAddress if empty.";
      };
    };
  };

  flake.modules.systemManager.base =
    { config, ... }:
    let
      tailscaleHost =
        lib.mkIf
          (
            config.my.networking.tailscale
            && config.my.networking.bindAddress != config.my.networking.publicHost
          )
          {
            ${config.my.networking.bindAddress} = [ config.my.networking.publicHost ];
          };
    in
    {
      networking.hosts = tailscaleHost;
    };
}
