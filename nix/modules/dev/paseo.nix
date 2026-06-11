{ inputs, ... }:
{
  flake.modules.nixos.paseo =
    {
      config,
      ...
    }:
    {
      imports = [ inputs.paseo.nixosModules.default ];

      services.paseo = {
        enable = true;
        user = config.my.username;
        group = "users";
        port = 6767;
        listenAddress = "127.0.0.1";
        relay.enable = false;
        hostnames = [ "${config.my.networking.publicHost}" ];
      };

      services.tailscale.serve = {
        services.paseo = {
          endpoints = {
            "tcp:6767" = "tcp://127.0.0.1:6767";
          };
        };
      };
    };
}
