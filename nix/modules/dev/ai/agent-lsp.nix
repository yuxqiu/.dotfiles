{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, config, lib, ... }:
    let
      agent-lsp = pkgs.callPackage (inputs.self + /packages/agent-lsp.nix) { };
    in
    {
      home.packages = [ agent-lsp ];

      programs.mcp.servers.lsp = {
        command = "agent-lsp";
        args = lib.flatten (lib.mapAttrsToList (_: lang:
          lib.flatten (map (s:
            map (ft:
              "${ft}:${s.binary}${lib.optionalString (s.extraArgs != []) ("," + lib.concatStringsSep "," s.extraArgs)}"
            ) s.filetypes
          ) lang.lsp)
        ) config.my.dev.languages);
      };
    };
}
