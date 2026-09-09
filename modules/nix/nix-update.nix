{ inputs, ... }:
{
  flake.modules.homeManager.nix-update =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.nix-update-git.packages.${pkgs.stdenv.system}.default
      ];
    };
}
