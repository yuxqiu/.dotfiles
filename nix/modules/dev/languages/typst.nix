{
  flake.modules.homeManager.typst =
    { pkgs, ... }:
    {
      my.dev.languages.typst = {
        toolchain = [ pkgs.typst ];
        lsp = [
          {
            server = "tinymist";
            package = pkgs.tinymist;
            binary = "tinymist";
            extraArgs = [ "lsp" ];
          }
        ];
        treesitter = [ "typst" ];
      };
    };
}
