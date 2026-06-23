{
  flake.modules.homeManager.typescript =
    { pkgs, ... }:
    {
      my.dev.languages.typescript = {
        lsp = [
          {
            server = "tsls";
            package = pkgs.typescript-language-server;
            binary = "typescript-language-server";
            extraArgs = [ "--stdio" ];
            filetypes = [ "typescript" "javascript" ];
          }
        ];
      };
    };
}
