{
  flake.modules.homeManager.lua =
    { pkgs, ... }:
    {
      my.dev.languages.lua = {
        lsp = [ pkgs.lua-language-server ];
        formatter = pkgs.stylua;
      };
    };
}
