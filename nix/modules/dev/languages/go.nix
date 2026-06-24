{
  flake.modules.homeManager.go =
    { pkgs, ... }:
    {
      my.dev.languages.go = {
        toolchain = [ pkgs.go ];
        lsp = [ pkgs.gopls ];
        formatter = pkgs.go;
        linter = [ pkgs.golangci-lint ];
      };
    };
}
