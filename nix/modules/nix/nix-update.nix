{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.nix-update-git.packages.${pkgs.stdenv.system}.default
      ];
    };
}
