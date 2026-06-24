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
          }
        ];
        formatter = {
          cmd = "prettier";
          package = pkgs.prettier;
        };
        linter = [
          {
            name = "yamllint";
            package = pkgs.yamllint;
          }
        ];
        treesitter = [ "yaml" ];
      };
    };
}
