{
  flake.modules.homeManager.jsoncss =
    { pkgs, ... }:
    {
      my.dev.languages.jsoncss = {
        lsp = [ pkgs.vscode-langservers-extracted ];
        formatter = pkgs.prettier;
      };
    };
}
