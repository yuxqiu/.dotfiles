{ inputs, ... }:
{
  flake.modules.homeManager.freebuff =
    { pkgs, ... }:
    let
      freebuff = pkgs.callPackage (inputs.self + /packages/freebuff.nix) { };
    in
    {
      home.packages = [ freebuff ];
    };
}
