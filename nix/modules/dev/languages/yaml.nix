{
  flake.modules.homeManager.yaml =
    { pkgs, ... }:
    {
      my.dev.languages.yaml = {
        lsp = [
          {
            server = "yamlls";
            package = pkgs.yaml-language-server;
            binary = "yaml-language-server";
            extraArgs = [ "--stdio" ];
            filetypes = [ "yaml" ];
          }
        ];
        linter = [
          {
            name = "yamllint";
            package = pkgs.yamllint;
            filetypes = [ "yaml" ];
          }
        ];
        treesitter = [ "yaml" ];
      };
    };
}
