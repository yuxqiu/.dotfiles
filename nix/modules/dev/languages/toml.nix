{
  flake.modules.homeManager.toml =
    { pkgs, ... }:
    {
      my.dev.languages.toml = {
        lsp = [
          {
            server = "taplo";
            package = pkgs.taplo;
            binary = "taplo";
            extraArgs = [ "lsp" "stdio" ];
          }
        ];
        formatter = {
          cmd = "taplo";
          package = pkgs.taplo;
        };
        treesitter = [ "toml" ];
      };
    };
}
