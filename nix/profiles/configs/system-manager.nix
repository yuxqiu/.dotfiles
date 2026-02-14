# modules/flake/home-configs.nix  (or similar)
{
  lib,
  config,
  inputs,
  ...
}:

{
  options.configurations.systemManager = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            example = "aarch64-linux";
            description = "Target system/platform for this home configuration";
          };

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
            description = "List of modules for this configuration";
          };
        };
      }
    );

    default = { };
  };

  config.flake.systemConfigs = lib.mapAttrs (
    name: cfg:
    inputs.system-manager.lib.makeSystemConfig {
      modules = cfg.modules ++ [
        {
          nixpkgs.hostPlatform = cfg.system;
        }
      ];
    }
  ) config.configurations.systemManager;
}
