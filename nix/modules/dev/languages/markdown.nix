{
  flake.modules.homeManager.markdown =
    { pkgs, ... }:
    {
      my.dev.languages.markdown = {
        lsp = [
          {
            server = "markdown_oxide";
            package = pkgs.markdown-oxide;
            binary = "markdown-oxide";
            filetypes = [ "markdown" ];
          }
        ];
        treesitter = [ "markdown" "markdown_inline" ];
      };
    };
}
