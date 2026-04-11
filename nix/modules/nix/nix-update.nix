{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.update-nix-fetchgit
        inputs.nix-update-git.packages.${pkgs.stdenv.system}.default
      ];
    };
}
