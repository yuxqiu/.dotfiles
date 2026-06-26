{ inputs, ... }:
{
  flake.modules.homeManager.openwork =
    { pkgs, ... }:
    let
      openwork = pkgs.callPackage (inputs.self + /packages/openwork.nix) { };
    in
    {
      home.packages = [ openwork ];
    };
}
