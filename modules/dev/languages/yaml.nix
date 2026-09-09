{
  flake.modules.homeManager.yaml =
    { pkgs, ... }:
    {
      my.dev.languages.yaml = {
        lsp = [ pkgs.yaml-language-server ];
        formatter = pkgs.prettier;
        linter = [ pkgs.yamllint ];
      };
    };
}
