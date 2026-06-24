{
  flake.modules.homeManager.typst =
    { pkgs, ... }:
    {
      my.dev.languages.typst = {
        toolchain = [ pkgs.typst ];
        lsp = [ pkgs.tinymist ];
      };
    };
}
