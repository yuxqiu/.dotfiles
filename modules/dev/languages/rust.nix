{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      my.dev.languages.rust = {
        toolchain = [ pkgs.rustup ];
        lsp = [ pkgs.rustup ];
        formatter = pkgs.rustup;
        linter = [ pkgs.rustup ];
      };
    };
}
