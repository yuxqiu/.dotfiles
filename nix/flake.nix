{
  description = "yuxqiu's dotfiles";

  inputs = {
    # User
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # System
    # Blocker: https://github.com/nix-community/nixos-apple-silicon/issues/380
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    # will be appended to the system-level substituters
    extra-substituters = [
      # cache mirror located in China

      # status: https://mirror.sjtu.edu.cn/
      # "https://mirror.sjtu.edu.cn/nix-channels/store"

      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, nix-vscode-extensions
    , system-manager, nix-system-graphics, ... }@inputs:
    let
      # Define supported systems
      hm-systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      sm-systems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate outputs for each system
      hm-forAllSystems = nixpkgs.lib.genAttrs hm-systems;
      sm-forAllSystems = nixpkgs.lib.genAttrs sm-systems;

      # Username for Home Manager
      username = "yuxqiu";
    in {
      # Home Manager configurations for each system
      homeConfigurations = hm-forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-vscode-extensions.overlays.default ];
          };

          # Conditionally select system-specific module
          systemModule = if (pkgs.stdenv.isLinux) then
            ./modules/hm/linux/default.nix
          else if (pkgs.stdenv.isDarwin) then
            ./modules/hm/darwin/default.nix
          else
            throw "Unsupported system: ${system}";
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            # Common settings
            ./modules/hm/common/default.nix

            # System-specific settings
            systemModule
            # Conditionally include nix-flatpak for Linux systems
            (nixpkgs.lib.optionalAttrs (pkgs.stdenv.isLinux) {
              imports = [ nix-flatpak.homeManagerModules.nix-flatpak ];
            })

            # User-specific settings
            (import ./users/${username}.nix { inherit pkgs; })
            ./users/options.nix

            # Avoid gc cleaning the source
            ({ lib, inputs, ... }: {
              home.file = builtins.listToAttrs (builtins.map (input:
                lib.attrsets.nameValuePair "sources/${input}" {
                  source = inputs.${input};
                }) (builtins.attrNames inputs));
            })
          ];
        });

      systemConfigs = sm-forAllSystems (system:
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

            ./modules/sm/linux/default.nix

            # Additional inputs
            { _module.args = { inherit username; }; }
          ];
        });
    };
}
