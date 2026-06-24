{
  flake.modules.homeManager.nix-lang =
    { pkgs, ... }:
    {
      my.dev.languages.nix = {
        lsp = [
          {
            server = "nixd";
            package = pkgs.nixd;
            binary = "nixd";
          }
        ];
        formatter = {
          cmd = "nixfmt";
          package = pkgs.nixfmt;
        };
        linter = [
          {
            name = "deadnix";
            package = pkgs.deadnix;
          }
          {
            name = "statix";
            package = pkgs.statix;
          }
        ];
        treesitter = [ "nix" ];
      };
    };
}
