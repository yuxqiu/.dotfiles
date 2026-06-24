{
  flake.modules.homeManager.typos =
    { pkgs, ... }:
    {
      my.dev.languages.typos = {
        lsp = [ pkgs.typos-lsp ];
      };
    };
}
