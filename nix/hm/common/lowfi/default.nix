{ pkgs, ... }:

let
  lowfi = pkgs.callPackage ./lowfi.nix { };
in
{
  home.packages = [ lowfi ];
}
