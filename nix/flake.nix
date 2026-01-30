{
  description = "yuxqiu's dotfiles";

  inputs = {
    # Common
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ssh-agent-ac = {
      url = "github:yuxqiu/ssh-agent-ac";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tun2proxy = {
      url = "github:yuxqiu/tun2proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      system-manager,
      nix-system-graphics,
      stylix,
      nix-index-database,
      ...
    }@inputs:
    let
      # Define supported systems
      hm-systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      sm-systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Helper function to generate outputs for each system
      hm-forAllSystems = nixpkgs.lib.genAttrs hm-systems;
      sm-forAllSystems = nixpkgs.lib.genAttrs sm-systems;

      # Username for Home Manager
      username = "yuxqiu";
    in
    {
      # Home Manager configurations for each system
      homeConfigurations = hm-forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              nix-vscode-extensions.overlays.default
            ];
          };

          # Conditionally select system-specific module
          systemModule =
            if (pkgs.stdenv.isLinux) then
              ./hm/linux/default.nix
            else if (pkgs.stdenv.isDarwin) then
              ./hm/darwin/default.nix
            else
              throw "Unsupported system: ${system}";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            # Common settings
            nix-index-database.homeModules.nix-index
            stylix.homeModules.stylix
            ./hm/common/default.nix

            # System-specific settings
            systemModule

            # User-specific settings
            (import ./users/${username}.nix { inherit pkgs; })
            ./users/dotfiles.nix
            ./users/keys.nix

            # Avoid gc cleaning the source
            (
              { lib, inputs, ... }:
              {
                home.file = builtins.listToAttrs (
                  map (
                    input:
                    lib.attrsets.nameValuePair "sources/${input}" {
                      source = inputs.${input};
                    }
                  ) (builtins.attrNames inputs)
                );
              }
            )
          ];
        }
      );

      systemConfigs = sm-forAllSystems (
        system:
        system-manager.lib.makeSystemConfig {
          modules = [
            nix-system-graphics.systemModules.default

            {
              config = {
                nixpkgs.hostPlatform = system;
                system-manager.allowAnyDistro = true;
                system-graphics.enable = true;
              };
            }

            ./sm/linux/default.nix

            # Additional inputs
            {
              _module.args = {
                inherit username;
                inherit inputs;
              };
            }
          ];
        }
      );
    };
}
