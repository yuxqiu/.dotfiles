{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    nix = {
      enable = true;
      # Manage nixpkgs channel used by
      # nix-shell
      channels = {
        nixpkgs = inputs.nixpkgs;
      };
    };
  };
}
