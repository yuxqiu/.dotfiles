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
          }
        ];
        formatter = {
          cmd = "gofmt";
          package = pkgs.go;
        };
        linter = [
          {
            name = "golangcilint";
            package = pkgs.golangci-lint;
          }
        ];
        treesitter = [ "go" ];
      };
    };
}
