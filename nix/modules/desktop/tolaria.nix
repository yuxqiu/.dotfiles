{ inputs, ... }:
{
  flake.modules.homeManager.tolaria =
    { pkgs, ... }:
    let
      tolaria = pkgs.callPackage (inputs.self + /packages/tolaria.nix) { };
    in
    {
      home.packages = [ tolaria ];
    };
}
