{
  lib,
  config,
  inputs,
  ...
}:

{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            example = "aarch64-linux";
            description = "Target system/platform for this NixOS configuration";
          };

          username = lib.mkOption {
            type = lib.types.str;
            description = "Username for the home-manager user";
          };

          homeStateVersion = lib.mkOption {
            type = lib.types.str;
            description = "Home Manager state version";
          };

          nixosStateVersion = lib.mkOption {
            type = lib.types.str;
            description = "NixOS system state version";
          };

          homeManagerModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
            description = "List of home-manager modules to include for this NixOS configuration";
          };

          modules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
            description = "List of modules for this NixOS configuration";
          };
        };
      }
    );

    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (cfg) system;
      specialArgs = { inherit inputs; };
      modules =
        cfg.modules
        ++ [
          { system.stateVersion = cfg.nixosStateVersion; }
        ]
        ++ (lib.optional (cfg.homeManagerModules != [ ]) {
          home-manager.users.${cfg.username} = {
            imports = cfg.homeManagerModules;
            home.stateVersion = cfg.homeStateVersion;
          };
          home-manager.sharedModules = [
            inputs.self.modules.generic.base
            {
              nixpkgs.config = config.nixpkgs.config;
              nixpkgs.overlays = config.nixpkgs.overlays;
            }
          ];
        });
    }
  ) config.configurations.nixos;
}
