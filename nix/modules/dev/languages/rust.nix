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
          }
        ];
        formatter = {
          cmd = "rustfmt";
          package = pkgs.rustup;
        };
        linter = [
          {
            name = "clippy";
            package = pkgs.rustup;
          }
        ];
        treesitter = [ "rust" ];
      };
    };
}
