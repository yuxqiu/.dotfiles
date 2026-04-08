# modules/flake/home-configs.nix  (or similar)
{
  lib,
  config,
  inputs,
  ...
}:

{
  options.configurations.homeManager = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            example = "aarch64-linux";
            description = "Target system/platform for this home configuration";
          };

          username = lib.mkOption {
            type = lib.types.str;
            example = "alice";
            description = "User name for this home configuration";
          };

          homeDirectory = lib.mkOption {
            type = lib.types.str;
            example = "/home/alice";
            description = "Absolute home directory path for this home configuration";
          };

          stateVersion = lib.mkOption {
            type = lib.types.str;
            example = "26.05";
            description = "Home Manager state version";
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

  config.flake.homeConfigurations = lib.mapAttrs (
    name: cfg:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit (cfg) system;
        inherit (config.nixpkgs) config overlays;
      };

      modules = cfg.modules ++ [
        {
          home.username = cfg.username;
          home.homeDirectory = cfg.homeDirectory;
          home.stateVersion = cfg.stateVersion;
        }
      ];
    }
  ) config.configurations.homeManager;
}
