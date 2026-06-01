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
        ++ (
          lib.optional (cfg.homeManagerModules != [ ]) {
            home-manager.users.yuxqiu = {
              imports = cfg.homeManagerModules;
              home.stateVersion = "26.11";
            };
            home-manager.sharedModules = [ inputs.self.modules.generic.base ];
          }
        );
    }
  ) config.configurations.nixos;
}