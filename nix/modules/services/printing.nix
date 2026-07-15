{
  flake.modules.nixos.printing = {
    services.printing.enable = true;
  };

  flake.modules.homeManager.printing =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.system-config-printer ];
    };
}
