{
  flake.modules.homeManager.nix-lang =
    { pkgs, ... }:
    {
      my.dev.languages.nix = {
        lsp = [ pkgs.nixd ];
        formatter = pkgs.nixfmt;
        linter = [
          pkgs.deadnix
          pkgs.statix
        ];
      };
    };
}
