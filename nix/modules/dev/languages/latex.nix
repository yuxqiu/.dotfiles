{
  flake.modules.homeManager.latex =
    { pkgs, ... }:
    {
      my.dev.languages.latex = {
        toolchain = [ pkgs.tectonic ];
        lsp = [
          {
            server = "texlab";
            package = pkgs.texlab;
            binary = "texlab";
            filetypes = [ "latex" ];
          }
        ];
        formatter = {
          cmd = "latexindent";
          package = pkgs.texliveSmall.withPackages (ps: with ps; [
            latexindent
            synctex
          ]);
          filetypes = [ "tex" "bib" ];
        };
        treesitter = [ "latex" ];
      };
    };
}
