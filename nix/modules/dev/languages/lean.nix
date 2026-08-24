{
  flake.modules.homeManager.lean =
    { pkgs, ... }:
    {
      my.dev.languages.lean = {
        toolchain = [ pkgs.elan ];
        lsp = [ pkgs.elan ];
        formatter = pkgs.elan;
        linter = [ pkgs.elan ];
      };
    };
}
