{
  flake.modules.homeManager.json =
    { pkgs, ... }:
    {
      my.dev.languages.json = {
        lsp = [ pkgs.vscode-langservers-extracted ];
        formatter = pkgs.prettier;
      };
    };
}
