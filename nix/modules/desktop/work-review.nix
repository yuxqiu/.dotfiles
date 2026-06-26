{ inputs, ... }:
{
  flake.modules.homeManager.work-review =
    { pkgs, ... }:
    let
      work-review = pkgs.callPackage (inputs.self + /packages/work-review.nix) { };
    in
    {
      home.packages = [ work-review ];
    };
}
