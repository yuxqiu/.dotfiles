{
  flake.modules.systemManager.display-manager =
    {
      nixosModulesPath,
      lib,
      ...
    }:
    {
      imports = [ (nixosModulesPath + "/services/display-managers/default.nix") ];

      options.services.displayManager = {
        environment = lib.mkOption { type = lib.types.raw; };
        execCmd = lib.mkOption { type = lib.types.raw; };
        preStart = lib.mkOption { type = lib.types.raw; };
      };

      config.services.displayManager.enable = true;
    };
}
