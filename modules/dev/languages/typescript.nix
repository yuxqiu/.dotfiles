{
  flake.modules.homeManager.typescript =
    { pkgs, ... }:
    {
      my.dev.languages.typescript = {
        lsp = [ pkgs.typescript-language-server ];
        formatter = pkgs.prettier;
      };
    };
}
