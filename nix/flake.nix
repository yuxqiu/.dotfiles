{
  description = "yuxqiu's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, nixGL, ... }:
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
            overlays = [ nixGL.overlay ];
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
          ];

          extraSpecialArgs = { inherit nixGL; };
        });
    };
}
