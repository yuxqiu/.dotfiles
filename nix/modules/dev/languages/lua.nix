{
  flake.modules.homeManager.lua =
    { pkgs, ... }:
    {
      my.dev.languages.lua = {
        lsp = [
          {
            server = "lua_ls";
            package = pkgs.lua-language-server;
            binary = "lua-language-server";
            filetypes = [ "lua" ];
          }
        ];
        treesitter = [ "lua" ];
      };
    };
}
