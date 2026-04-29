{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      tolaria = pkgs.callPackage (inputs.self + /packages/tolaria.nix) { };
    in
    {
      home.packages = [ tolaria ];
    };
}
