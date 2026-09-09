{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.networking = {
      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address to bind/listen on for networking. Defaults to loopback, but should be set to your public IP if desired.";
      };

      publicHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Public hostname for external access (e.g., hostname.ts.net). Defaults to bindAddress if empty.";
      };
    };
  };
}
