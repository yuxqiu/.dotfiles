{
  flake.modules.systemManager.display-manager =
    {
      nixosModulesPath,
      lib,
      ...
    }:
    {
      imports = [ (nixosModulesPath + "/services/display-managers/default.nix") ];

      options = {
        services.displayManager.environment = lib.mkOption {
          type = lib.types.raw;
        };
        services.displayManager.execCmd = lib.mkOption {
          type = lib.types.str;
        };
        services.displayManager.preStart = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };

      config.services.displayManager = {
        enable = true;
      };
    };

  flake.modules.nixos.display-manager = {
    services.greetd = {
      enable = true;
    };
  };
}
