{
  flake.modules.generic.yuxqiu-cedrus = {
    my = {
      networking = {
        bindAddress = "100.99.246.87";
        publicHost = "cedrus.taile30f2a.ts.net";
      };
    };
  };

  flake.modules.nixos.yuxqiu-cedrus =
    { config, ... }:
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale_key_cedrus".path;
      };
      sops.secrets."tailscale_key_cedrus" = {
        mode = "0400";
        owner = config.users.users.root.name;
        restartUnits = [ "tailscaled.service" ];
      };
    };
}
