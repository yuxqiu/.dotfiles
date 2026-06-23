{
  flake.modules.homeManager.typos =
    { pkgs, ... }:
    {
      my.dev.languages.typos = {
        lsp = [
          {
            server = "typos_lsp";
            package = pkgs.typos-lsp;
            binary = "typos-lsp";
          }
        ];
      };
    };
}
