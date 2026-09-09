{
  flake.modules.homeManager.latex =
    { pkgs, ... }:
    {
      my.dev.languages.latex = {
        toolchain = [ pkgs.tectonic ];
        lsp = [ pkgs.texlab ];
        formatter = pkgs.texliveSmall.withPackages (
          ps: with ps; [
            latexindent
            synctex
          ]
        );
      };
    };
}
