{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      lib,
      pkgs,
      ...
    }:
    let
      excalidrawMcp = pkgs.callPackage (inputs.self + /packages/excalidraw.nix) { };
    in
    {
      programs.mcp = {
        enable = true;
        servers = {
          excalidraw = {
            command = lib.getExe excalidrawMcp;
            args = [ "--stdio" ];
          };
        };
      };
    };
}
