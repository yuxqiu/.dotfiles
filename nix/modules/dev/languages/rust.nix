{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      my.dev.languages.rust = {
        toolchain = [ pkgs.rustup ];
        lsp = [
          {
            server = "rust_analyzer";
            package = pkgs.rustup;
            binary = "rust-analyzer";
            filetypes = [ "rust" ];
          }
        ];
        linter = [
          {
            name = "clippy";
            package = pkgs.rustup;
            filetypes = [ "rust" ];
          }
        ];
        treesitter = [ "rust" ];
      };
    };
}
