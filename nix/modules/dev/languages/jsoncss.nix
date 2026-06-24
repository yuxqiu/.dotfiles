{
  flake.modules.homeManager.jsoncss =
    { pkgs, ... }:
    {
      my.dev.languages.jsoncss = {
        lsp = [
          {
            server = "jsonls";
            package = pkgs.vscode-langservers-extracted;
            binary = "vscode-json-language-server";
            extraArgs = [ "--stdio" ];
            filetypes = [ "json" ];
          }
          {
            server = "cssls";
            package = pkgs.vscode-langservers-extracted;
            binary = "vscode-css-language-server";
            extraArgs = [ "--stdio" ];
            filetypes = [ "css" "scss" ];
          }
        ];
        formatter = {
          cmd = "prettier";
          package = pkgs.prettier;
          filetypes = [ "json" "css" "scss" ];
        };
        treesitter = [ "json" "scss" ];
      };
    };
}
