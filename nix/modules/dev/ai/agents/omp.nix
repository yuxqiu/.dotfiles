{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = [ inputs.omp.packages.${pkgs.stdenv.system}.default ];
    };
}
