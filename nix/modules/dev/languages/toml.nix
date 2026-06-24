{
  flake.modules.homeManager.toml =
    { pkgs, ... }:
    {
      my.dev.languages.toml = {
        lsp = [ pkgs.taplo ];
        formatter = pkgs.taplo;
      };
    };
}
