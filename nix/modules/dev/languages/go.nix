{
  flake.modules.homeManager.go =
    { pkgs, ... }:
    {
      my.dev.languages.go = {
        toolchain = [ pkgs.go ];
        lsp = [
          {
            server = "gopls";
            package = pkgs.gopls;
            binary = "gopls";
            filetypes = [ "go" ];
          }
        ];
        linter = [
          {
            name = "golangcilint";
            package = pkgs.golangci-lint;
            filetypes = [ "go" ];
          }
        ];
        treesitter = [ "go" ];
      };
    };
}
