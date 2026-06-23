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
            filetypes = [ "nix" ];
          }
        ];
        formatter = {
          cmd = "nixfmt";
          package = pkgs.nixfmt;
          filetypes = [ "nix" ];
        };
        linter = [
          {
            name = "deadnix";
            package = pkgs.deadnix;
            filetypes = [ "nix" ];
          }
          {
            name = "statix";
            package = pkgs.statix;
            filetypes = [ "nix" ];
          }
        ];
        treesitter = [ "nix" ];
      };
    };
}
