{
  flake.modules.homeManager.typescript =
    { pkgs, ... }:
    {
      my.dev.languages.typescript = {
        lsp = [
          {
            server = "ts_ls";
            package = pkgs.typescript-language-server;
            binary = "typescript-language-server";
            extraArgs = [ "--stdio" ];
            filetypes = [ "typescript" "javascript" ];
          }
        ];
      };
    };
}
