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

    let
      username = builtins.head (lib.splitString "@" name);

      # Compute once, outside module evaluation
      homeDirPrefix =
        # You cannot use pkgs.stdenv here either – so use a simple heuristic
        # or accept that you need to know the platform in advance
        if
          cfg.system == "aarch64-linux" || cfg.system == "x86_64-linux" || cfg.system == "armv7l-linux"
        then
          "/home"
        else if cfg.system == "aarch64-darwin" || cfg.system == "x86_64-darwin" then
          "/Users"
        else
          throw "Unsupported system for automatic home directory prefix: ${cfg.system}";

      homeDirectory = "${homeDirPrefix}/${username}";
    in

    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit (cfg) system;
        inherit (config.nixpkgs) config overlays;
      };

      modules = cfg.modules ++ [
        {
          home.username = username;
          home.homeDirectory = homeDirectory;
          home.stateVersion = cfg.stateVersion;
        }
      ];
    }
  ) config.configurations.homeManager;
}
