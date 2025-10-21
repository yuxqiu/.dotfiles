{
  description = "yuxqiu's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, nix-vscode-extensions, nixGL
    , system-manager, ... }@inputs:
    let
      # Define supported systems
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate outputs for each system
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Username for Home Manager
      username = "yuxqiu";
    in {
      # Home Manager configurations for each system
      homeConfigurations = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-vscode-extensions.overlays.default ];
          };

          # Conditionally select system-specific module
          systemModule = if (builtins.match ".*-linux" system != null) then
            ./modules/linux/default.nix
          else if (builtins.match ".*-darwin" system != null) then
            ./modules/darwin/default.nix
          else
            throw "Unsupported system: ${system}";
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            # Common settings
            ./modules/common/default.nix

            # System-specific settings
            systemModule
            # Conditionally include nix-flatpak for Linux systems
            (nixpkgs.lib.optionalAttrs (pkgs.stdenv.isLinux) {
              imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
            })

            # User-specific settings
            (import ./users/${username}.nix { inherit system pkgs; })

            # Additional inputs
            {
              _module.args = {
                inherit system;
                nixGL = nixGL; # Pass nixGL input to home.nix
              };
            }

            # Avoid gc cleaning the source
            ({ lib, inputs, ... }: {
              home.file = builtins.listToAttrs (builtins.map (input:
                lib.attrsets.nameValuePair "sources/${input}" {
                  source = inputs.${input};
                }) (builtins.attrNames inputs));
            })
          ];
        });

      systemConfigs = forAllSystems (system:
        system-manager.lib.makeSystemConfig {
          modules = [
            ./modules/linux/system-manager.nix

            # Additional inputs
            { _module.args = { inherit system; }; }
          ];
        });
    };
}
