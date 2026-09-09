{
  flake.modules.homeManager.css =
    { pkgs, ... }:
    {
      my.dev.languages.css = {
        lsp = [ pkgs.vscode-langservers-extracted ];
        formatter = pkgs.prettier;
      };
    };
}
