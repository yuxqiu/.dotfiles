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
          }
        ];
        formatter = {
          cmd = "prettier";
          package = pkgs.prettier;
        };
        treesitter = [ "markdown" "markdown_inline" ];
      };
    };
}
